#!/usr/bin/env bash

set -uo pipefail

SCRIPT_PATH="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)/$(basename -- "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname -- "$SCRIPT_PATH")"
CONFIG_FILE="${CMANGOS_RESTARTER_CONFIG:-$SCRIPT_DIR/cmangos-restarter.conf}"

if [[ ! -r "$CONFIG_FILE" ]]; then
    echo "Configuration not found: $CONFIG_FILE" >&2
    exit 1
fi

# shellcheck source=cmangos-restarter.conf
source "$CONFIG_FILE"

: "${AUTH_PATH:?AUTH_PATH is required}"
: "${WORLD_PATH:?WORLD_PATH is required}"
: "${LOG_PATH:?LOG_PATH is required}"
: "${AUTH_BINARY:=realmd}"
: "${WORLD_BINARY:=mangosd}"
: "${AUTH_SESSION:=tbc-realmd}"
: "${WORLD_SESSION:=tbc-mangosd}"
: "${RESTART_DELAY:=5}"
: "${SHUTDOWN_WAIT:=30}"
: "${DEBUG_WITH_GDB:=false}"

mkdir -p "$LOG_PATH" "$LOG_PATH/crashes" "$LOG_PATH/state"

MAIN_LOG="$LOG_PATH/restarter.log"
WORLD_LOG="$LOG_PATH/mangosd.log"
AUTH_LOG="$LOG_PATH/realmd.log"
WORLD_ENABLED="$LOG_PATH/state/world.enabled"
AUTH_ENABLED="$LOG_PATH/state/auth.enabled"

timestamp() { date '+%Y-%m-%d %H:%M:%S'; }
log() { echo "[$(timestamp)] $*" | tee -a "$MAIN_LOG"; }

require_command()
{
    command -v "$1" >/dev/null 2>&1 || {
        log "Required command not found: $1"
        exit 1
    }
}

session_exists()
{
    screen -S "$1" -Q select . >/dev/null 2>&1
}

send_world()
{
    session_exists "$WORLD_SESSION" || return 1
    screen -S "$WORLD_SESSION" -p 0 -X stuff "$1$(printf '\r')"
}

write_gdb_commands()
{
    local command_file="$1"
    {
        echo "set pagination off"
        echo "run"
        echo "echo \\nCRASHLOG BEGIN\\n"
        echo "info program"
        echo "echo \\nBACKTRACE\\n"
        echo "bt"
        echo "echo \\nBACKTRACE FULL\\n"
        echo "bt full"
        echo "echo \\nTHREADS\\n"
        echo "info threads"
        echo "echo \\nTHREADS BACKTRACE\\n"
        echo "thread apply all bt full"
    } > "$command_file"
}

run_world()
{
    cd "$WORLD_PATH" || exit 1
    local rc crash_file command_file

    while [[ -f "$WORLD_ENABLED" ]]; do
        log "Starting $WORLD_BINARY"
        if [[ "$DEBUG_WITH_GDB" == "true" ]]; then
            require_command gdb
            crash_file="$LOG_PATH/crashes/mangosd-$(date '+%Y%m%d-%H%M%S').log"
            command_file="$LOG_PATH/state/gdbcommands"
            write_gdb_commands "$command_file"
            set +e
            gdb "./$WORLD_BINARY" --batch -x "$command_file" 2>&1 | tee -a "$WORLD_LOG" "$crash_file"
            rc=${PIPESTATUS[0]}
            set -e
            log "$WORLD_BINARY stopped with status $rc; crash log: $crash_file"
        else
            set +e
            "./$WORLD_BINARY" 2>&1 | tee -a "$WORLD_LOG"
            rc=${PIPESTATUS[0]}
            set -e
            log "$WORLD_BINARY stopped with status $rc"
        fi

        [[ -f "$WORLD_ENABLED" ]] || break
        log "Restarting $WORLD_BINARY in $RESTART_DELAY seconds"
        sleep "$RESTART_DELAY"
    done
    log "$WORLD_BINARY supervisor stopped"
}

run_auth()
{
    cd "$AUTH_PATH" || exit 1
    local rc

    while [[ -f "$AUTH_ENABLED" ]]; do
        log "Starting $AUTH_BINARY"
        set +e
        "./$AUTH_BINARY" 2>&1 | tee -a "$AUTH_LOG"
        rc=${PIPESTATUS[0]}
        set -e
        log "$AUTH_BINARY stopped with status $rc"
        [[ -f "$AUTH_ENABLED" ]] || break
        log "Restarting $AUTH_BINARY in $RESTART_DELAY seconds"
        sleep "$RESTART_DELAY"
    done
    log "$AUTH_BINARY supervisor stopped"
}

start_world()
{
    local debug_mode="${1:-$DEBUG_WITH_GDB}"
    require_command screen
    [[ -x "$WORLD_PATH/$WORLD_BINARY" ]] || {
        log "World binary is missing or not executable: $WORLD_PATH/$WORLD_BINARY"
        exit 1
    }
    if session_exists "$WORLD_SESSION"; then
        log "$WORLD_SESSION is already running"
        return
    fi
    touch "$WORLD_ENABLED"
    screen -DmS "$WORLD_SESSION" "$SCRIPT_PATH" __run_world "$debug_mode"
    sleep 1
    session_exists "$WORLD_SESSION" || {
        rm -f "$WORLD_ENABLED"
        log "Failed to start $WORLD_SESSION; check $WORLD_LOG"
        exit 1
    }
    log "$WORLD_SESSION started"
}

start_auth()
{
    require_command screen
    [[ -x "$AUTH_PATH/$AUTH_BINARY" ]] || {
        log "Auth binary is missing or not executable: $AUTH_PATH/$AUTH_BINARY"
        exit 1
    }
    if session_exists "$AUTH_SESSION"; then
        log "$AUTH_SESSION is already running"
        return
    fi
    touch "$AUTH_ENABLED"
    screen -DmS "$AUTH_SESSION" "$SCRIPT_PATH" __run_auth
    sleep 1
    session_exists "$AUTH_SESSION" || {
        rm -f "$AUTH_ENABLED"
        log "Failed to start $AUTH_SESSION; check $AUTH_LOG"
        exit 1
    }
    log "$AUTH_SESSION started"
}

wait_for_session()
{
    local session="$1" elapsed=0
    while session_exists "$session" && (( elapsed < SHUTDOWN_WAIT )); do
        sleep 1
        ((elapsed+=1))
    done
    if session_exists "$session"; then
        log "$session did not stop after $SHUTDOWN_WAIT seconds; closing screen"
        screen -S "$session" -X quit >/dev/null 2>&1 || true
    fi
}

stop_world()
{
    rm -f "$WORLD_ENABLED"
    if ! session_exists "$WORLD_SESSION"; then
        log "$WORLD_SESSION is not running"
        return
    fi
    send_world "saveall" || true
    log "saveall sent to $WORLD_SESSION"
    send_world "server shutdown 5" || true
    log "graceful shutdown sent to $WORLD_SESSION"
    wait_for_session "$WORLD_SESSION"
    log "$WORLD_SESSION stopped"
}

stop_auth()
{
    rm -f "$AUTH_ENABLED"
    if ! session_exists "$AUTH_SESSION"; then
        log "$AUTH_SESSION is not running"
        return
    fi
    screen -S "$AUTH_SESSION" -X stuff "$(printf '\003')" >/dev/null 2>&1 || true
    wait_for_session "$AUTH_SESSION"
    log "$AUTH_SESSION stopped"
}

restart_world()
{
    if session_exists "$WORLD_SESSION"; then
        send_world "saveall" || true
        send_world "server restart 5" || true
        log "In-game world restart scheduled in 5 seconds"
    else
        start_world
    fi
}

status()
{
    if session_exists "$WORLD_SESSION"; then echo "world: running ($WORLD_SESSION)"; else echo "world: stopped"; fi
    if session_exists "$AUTH_SESSION"; then echo "auth:  running ($AUTH_SESSION)"; else echo "auth:  stopped"; fi
    echo "logs:  $LOG_PATH"
}

monitor()
{
    local session="$1"
    session_exists "$session" || { log "$session is not running"; exit 1; }
    echo "Detach without stopping the server with Ctrl+A, then D."
    screen -r "$session"
}

case "${1:-}" in
    __run_world) DEBUG_WITH_GDB="${2:-$DEBUG_WITH_GDB}"; run_world ;;
    __run_auth) run_auth ;;
    start) start_auth; start_world ;;
    stop) stop_world; stop_auth ;;
    restart) stop_world; stop_auth; start_auth; start_world ;;
    wstart) start_world ;;
    wdstart) start_world true ;;
    wrestart) restart_world ;;
    wstop) stop_world ;;
    wmonitor) monitor "$WORLD_SESSION" ;;
    astart) start_auth ;;
    arestart) stop_auth; start_auth ;;
    astop) stop_auth ;;
    amonitor) monitor "$AUTH_SESSION" ;;
    status) status ;;
    logs) tail -n 100 "$MAIN_LOG" ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|logs|wstart|wdstart|wrestart|wstop|wmonitor|astart|arestart|astop|amonitor}"
        exit 1
        ;;
esac
