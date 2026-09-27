#!/usr/bin/env bash
# Merge official CMaNGOS updates into the current custom branches.
set -Eeuo pipefail

CORE_PATH="${CORE_PATH:-/home/matuph/source/cmangos/mangos-tbc}"
DB_PATH="${TBC_DB_PATH:-}"
CHECK_ONLY=false
SAVE_LOCAL=false
SUBMODULES=true
usage() {
    cat <<'HELP'
Usage: bash update-cmangos-sources.sh [options]
  --core-path PATH   Core repository (default /home/matuph/source/cmangos/mangos-tbc)
  --db-path PATH     TBC-DB repository (default: sibling tbc-db)
  --check            Fetch and report only; do not commit or merge
  --save-local       Commit existing tracked and untracked files before merging
  --no-submodules    Skip submodule synchronization
  -h, --help         Show help

Creates backup tags, retains custom changes, stops on conflicts. No push,
build, database import or server restart. Configure Git name/email first.
HELP
}
die() { echo "ERROR: $*" >&2; exit 1; }
while (($#)); do
    case "$1" in
        --core-path|--db-path)
            (($# >= 2)) || die "$1 requires a path"
            [[ -n "$2" && "$2" != --* ]] || die "$1 requires a path"
            if [[ "$1" == --core-path ]]; then CORE_PATH="$2"; else DB_PATH="$2"; fi
            shift 2 ;;
        --check) CHECK_ONLY=true; shift ;;
        --save-local) SAVE_LOCAL=true; shift ;;
        --no-submodules) SUBMODULES=false; shift ;;
        -h|--help) usage; exit 0 ;;
        *) die "Unknown option: $1" ;;
    esac
done
command -v git >/dev/null || die 'Git is required'
CORE_PATH="$(cd -- "$CORE_PATH" && pwd -P)" || die 'Core path not found'
DB_PATH="${DB_PATH:-$(dirname "$CORE_PATH")/tbc-db}"
DB_PATH="$(cd -- "$DB_PATH" && pwd -P)" || die 'TBC-DB path not found'
[[ "$CORE_PATH" != "$DB_PATH" ]] || die 'Core and DB must be different repositories'
paths=("$CORE_PATH" "$DB_PATH")
urls=(https://github.com/cmangos/mangos-tbc.git https://github.com/cmangos/tbc-db.git)
heads=()

# Preflight both repositories before modifying either working tree.
for path in "${paths[@]}"; do
    top="$(git -C "$path" rev-parse --show-toplevel)" || die "Not a repository: $path"
    [[ "$(cd -- "$top" && pwd -P)" == "$path" ]] || die "Use repository root: $top"
    git -C "$path" symbolic-ref --quiet HEAD >/dev/null || die "Detached HEAD: $path"
    for marker in MERGE_HEAD CHERRY_PICK_HEAD REVERT_HEAD rebase-merge rebase-apply; do
        state="$(git -C "$path" rev-parse --git-path "$marker")"
        [[ "$state" == /* || "$state" == ?:/* ]] || state="$path/$state"
        [[ ! -e "$state" ]] || die "Unfinished Git operation in $path ($marker)"
    done
    dirty="$(git -C "$path" status --porcelain)"
    if [[ "$CHECK_ONLY" == false ]]; then
        git -C "$path" var GIT_AUTHOR_IDENT >/dev/null || die "Configure Git user.name/email in $path"
        git -C "$path" var GIT_COMMITTER_IDENT >/dev/null || die "Configure Git user.name/email in $path"
        [[ -z "$dirty" || "$SAVE_LOCAL" == true ]] || die "Uncommitted changes in $path; commit first or use --save-local"
    fi
done

for i in 0 1; do
    path="${paths[$i]}"
    git -C "$path" fetch --no-tags "${urls[$i]}" master
    heads[$i]="$(git -C "$path" rev-parse FETCH_HEAD)"
    git -C "$path" merge-base HEAD "${heads[$i]}" >/dev/null || die "Unrelated histories: $path"
    echo "Repository: $path"
    echo "Missing official commits: $(git -C "$path" rev-list --count "HEAD..${heads[$i]}")"
    git -C "$path" log --oneline "HEAD..${heads[$i]}"
done
[[ "$CHECK_ONLY" == false ]] || exit 0

printf -v stamp '%(%Y%m%d-%H%M%S)T' -1
stamp="$stamp-$$"
for path in "${paths[@]}"; do
    git -C "$path" tag "backup/before-upstream-$stamp"
    if [[ -n "$(git -C "$path" status --porcelain)" ]]; then
        git -C "$path" add -A
        git -C "$path" commit -m "Preserve local custom changes before upstream update $stamp"
    fi
    git -C "$path" tag "backup/custom-snapshot-$stamp"
done
echo "Backup tags: backup/before-upstream-$stamp and backup/custom-snapshot-$stamp"

for i in 0 1; do
    path="${paths[$i]}"
    if ! git -C "$path" merge --no-edit "${heads[$i]}"; then
        echo "Update stopped in $path. Earlier repositories may already be updated." >&2
        echo "Inspect git status; resolve conflicts and commit, or cancel with git merge --abort." >&2
        echo "Local changes are saved in backup/custom-snapshot-$stamp." >&2
        exit 1
    fi
    git -C "$path" merge-base --is-ancestor "${heads[$i]}" HEAD
    if ! git -C "$path" diff --check "backup/custom-snapshot-$stamp" HEAD; then
        echo "Note: upstream includes whitespace warnings; review the output above." >&2
    fi
    if [[ "$SUBMODULES" == true && -f "$path/.gitmodules" ]]; then
        git -C "$path" submodule sync --recursive
        git -C "$path" submodule update --init --recursive
    fi
    git -C "$path" status --short --branch
done
echo 'Core and TBC-DB updated. Build and test before deploying.'
