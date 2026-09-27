#!/usr/bin/env bash

set -Eeuo pipefail

usage()
{
    echo "Aufruf: $0 [SERVER_NR] [--dry-run]"
    echo "Standard: Server 2, /home/matuph/build-2 und /home/matuph/wow-emu/wow-tbc-2"
    echo "Server 1 verwendet build und wow-tbc; Server 3, 4, ... entsprechend -3, -4, ..."
    echo "Optional: SERVER_ID, SOURCE_DIR, BUILD_DIR, INSTALL_DIR, JOBS (Standard: 16)."
}

SERVER_ID="${SERVER_ID:-2}"
DRY_RUN=false
server_argument=false
for argument in "$@"; do
    case "$argument" in
        -h|--help) usage; exit 0 ;;
        --dry-run) DRY_RUN=true ;;
        *)
            if [[ "$server_argument" == true || ! "$argument" =~ ^[1-9][0-9]{0,3}$ ]]; then
                echo "Fehler: Eine Servernummer zwischen 1 und 9999 angeben." >&2
                exit 1
            fi
            SERVER_ID="$argument"
            server_argument=true
            ;;
    esac
done

if [[ ! "$SERVER_ID" =~ ^[1-9][0-9]{0,3}$ ]]; then
    echo "Fehler: SERVER_ID muss zwischen 1 und 9999 liegen." >&2
    exit 1
fi

server_suffix="-$SERVER_ID"
if [[ "$SERVER_ID" == 1 ]]; then
    server_suffix=""
fi

SOURCE_DIR="${SOURCE_DIR:-/home/matuph/source/cmangos/mangos-tbc}"
BUILD_DIR="${BUILD_DIR:-/home/matuph/build${server_suffix}}"
INSTALL_DIR="${INSTALL_DIR:-/home/matuph/wow-emu/wow-tbc${server_suffix}}"
BUILD_TYPE="${BUILD_TYPE:-Release}"
USE_CCACHE="${USE_CCACHE:-ON}"

# Build with 16 parallel compiler processes by default. Override with JOBS=8, etc.
JOBS="${JOBS:-16}"

if [[ ! "$JOBS" =~ ^[1-9][0-9]*$ ]] || (( JOBS > 64 )); then
    echo "Fehler: JOBS muss eine Zahl zwischen 1 und 64 sein: $JOBS" >&2
    exit 1
fi

echo "Servernummer:   $SERVER_ID"
echo "Quellcode:       $SOURCE_DIR"
echo "Build-Ordner:    $BUILD_DIR"
echo "Installation:    $INSTALL_DIR"
echo "Build-Typ:       $BUILD_TYPE"
echo "Parallele Jobs:  $JOBS"

if [[ "$DRY_RUN" == true ]]; then
    echo "Vorschau: Es werden keine Verzeichnisse erstellt oder Builds ausgefuehrt."
    exit 0
fi

if [[ ! -f "$SOURCE_DIR/CMakeLists.txt" ]]; then
    echo "Fehler: Kein CMaNGOS-Quellcode unter $SOURCE_DIR" >&2
    exit 1
fi

for command_name in cmake; do
    command -v "$command_name" >/dev/null 2>&1 || {
        echo "Fehler: Programm nicht gefunden: $command_name" >&2
        exit 1
    }
done

mkdir -p "$BUILD_DIR" "$INSTALL_DIR"

cmake_options=(
    -S "$SOURCE_DIR"
    -B "$BUILD_DIR"
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE"
    -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR"
    -DBUILD_EXTRACTORS=OFF
    -DPCH=ON
    -DDEBUG=OFF
    -DBUILD_AHBOT=ON
    -DBUILD_PLAYERBOTS=OFF
    -DBUILD_GIT_ID=ON
    -DBUILD_MODULES=ON
    -DBUILD_MODULE_PLAYERTREFF=ON
    -DBUILD_MODULE_LEVEL58UPGRADE=ON
    -DBUILD_MODULE_HARDCORE=ON
    -DBUILD_MODULE_TRAININGDUMMIES=ON
)

if [[ "$USE_CCACHE" == "ON" ]] && command -v ccache >/dev/null 2>&1; then
    cmake_options+=(
        -DCMAKE_C_COMPILER_LAUNCHER=ccache
        -DCMAKE_CXX_COMPILER_LAUNCHER=ccache
    )
    echo "Compiler-Cache: aktiviert"
else
    echo "Compiler-Cache: nicht verwendet"
fi

start_time="$(date +%s)"
cmake "${cmake_options[@]}"
cmake --build "$BUILD_DIR" --parallel "$JOBS"
cmake --install "$BUILD_DIR"
elapsed="$(( $(date +%s) - start_time ))"

echo "CMaNGOS TBC wurde nach $INSTALL_DIR installiert."
echo "Vor dem Parallelbetrieb eigene World-/Characters-Datenbanken, Realm-ID und Ports konfigurieren."
printf 'Dauer: %d Minuten %d Sekunden\n' "$((elapsed / 60))" "$((elapsed % 60))"
