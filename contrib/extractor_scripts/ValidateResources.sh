#!/bin/sh
set -u

MODE="${1:-all}"
OUTPUT_PATH="${2:-.}"

fail() { echo "Resource validation failed: $*" >&2; exit 1; }

check_magic_files()
{
    directory="$1"; pattern="$2"; expected="$3"; length="$4"; minimum="$5"; label="$6"
    [ -d "$directory" ] || fail "$label directory not found: $directory"
    count=$(find "$directory" -type f -name "$pattern" | wc -l)
    [ "$count" -ge "$minimum" ] || fail "only $count $label files found (expected at least $minimum)"
    failures=$(mktemp) || fail "cannot create temporary validation file"
    find "$directory" -type f -name "$pattern" | while IFS= read -r file
    do
        [ "$(LC_ALL=C head -c "$length" "$file")" = "$expected" ] || echo "$file" >> "$failures"
    done
    if [ -s "$failures" ]; then
        echo "Invalid $label file headers:" >&2
        sed -n ''1,20p'' "$failures" >&2
        rm -f "$failures"
        fail "$label output contains invalid or truncated files"
    fi
    rm -f "$failures"
    echo "Validated $count $label files"
}

check_dbc_maps()
{
    for dbc in Map.dbc AreaTable.dbc LiquidType.dbc Spell.dbc AreaTrigger.dbc
    do
        [ -f "$OUTPUT_PATH/dbc/$dbc" ] || fail "required DBC missing: $dbc"
    done
    check_magic_files "$OUTPUT_PATH/dbc" '*.dbc' 'WDBC' 4 5 'DBC'
    check_magic_files "$OUTPUT_PATH/maps" '*.map' 'MAPSs1.4' 8 100 'map'
}

check_vmaps()
{
    check_magic_files "$OUTPUT_PATH/vmaps" '*.vmtree' 'VMAP_7.0' 8 1 'vmap tree'
    check_magic_files "$OUTPUT_PATH/vmaps" '*.vmtile' 'VMAP_7.0' 8 1 'vmap tile'
}

case "$MODE" in
    dbc-maps) check_dbc_maps ;;
    vmaps) check_vmaps ;;
    all) check_dbc_maps; check_vmaps ;;
    *) fail "unknown validation mode: $MODE" ;;
esac

echo "Resource validation completed successfully"
