#!/usr/bin/env bash

set -Eeuo pipefail

SOURCE_DIR="${SOURCE_DIR:-/home/matuph/source/cmangos/mangos-tbc}"
BUILD_DIR="${BUILD_DIR:-/home/matuph/build}"
INSTALL_DIR="${INSTALL_DIR:-/home/matuph/wow-emu/wow-tbc}"
BUILD_TYPE="${BUILD_TYPE:-Release}"
USE_CCACHE="${USE_CCACHE:-ON}"

choose_jobs()
{
    local cpu_count memory_kb
    cpu_count="$(nproc 2>/dev/null || echo 4)"
    memory_kb="$(awk '/^MemAvailable:/ { print $2; exit }' /proc/meminfo 2>/dev/null || echo 0)"

    # Six compiler processes need roughly 8 GiB available RAM for reliable
    # CMaNGOS builds. Four is a safer default on smaller virtual servers.
    if (( cpu_count >= 6 && (memory_kb == 0 || memory_kb >= 8 * 1024 * 1024) )); then
        echo 6
    elif (( cpu_count >= 4 )); then
        echo 4
    else
        echo "$cpu_count"
    fi
}

JOBS="${JOBS:-$(choose_jobs)}"

if [[ ! "$JOBS" =~ ^[1-9][0-9]*$ ]] || (( JOBS > 64 )); then
    echo "Fehler: JOBS muss eine Zahl zwischen 1 und 64 sein: $JOBS" >&2
    exit 1
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

echo "Quellcode:       $SOURCE_DIR"
echo "Build-Ordner:    $BUILD_DIR"
echo "Installation:    $INSTALL_DIR"
echo "Build-Typ:       $BUILD_TYPE"
echo "Parallele Jobs:  $JOBS"

start_time="$(date +%s)"
cmake "${cmake_options[@]}"
cmake --build "$BUILD_DIR" --parallel "$JOBS"
cmake --install "$BUILD_DIR"
elapsed="$(( $(date +%s) - start_time ))"

echo "CMaNGOS TBC wurde nach $INSTALL_DIR installiert."
printf 'Dauer: %d Minuten %d Sekunden\n' "$((elapsed / 60))" "$((elapsed % 60))"
