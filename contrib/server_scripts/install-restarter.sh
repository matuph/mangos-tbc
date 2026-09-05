#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
INSTALL_PATH="${1:-/home/matuph/wow-emu/wow-tbc}"
TARGET_DIR="$INSTALL_PATH/bin"

mkdir -p "$TARGET_DIR" "$INSTALL_PATH/logs/restarter"
install -m 0755 "$SCRIPT_DIR/cmangos-restarter.sh" "$TARGET_DIR/cmangos-restarter.sh"
install -m 0644 "$SCRIPT_DIR/cmangos-restarter.conf" "$TARGET_DIR/cmangos-restarter.conf"

echo "CMaNGOS restarter installed in $TARGET_DIR"
echo "Edit $TARGET_DIR/cmangos-restarter.conf if your paths differ."
echo "Start with: $TARGET_DIR/cmangos-restarter.sh start"
