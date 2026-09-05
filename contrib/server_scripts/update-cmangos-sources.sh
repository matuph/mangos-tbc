#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
CORE_PATH="$(cd -- "$SCRIPT_DIR/../.." && pwd -P)"
DB_PATH="${TBC_DB_PATH:-$(dirname "$CORE_PATH")/tbc-db}"
CORE_UPSTREAM_URL="${CORE_UPSTREAM_URL:-https://github.com/cmangos/mangos-tbc.git}"
DB_UPSTREAM_URL="${DB_UPSTREAM_URL:-https://github.com/cmangos/tbc-db.git}"
UPSTREAM_BRANCH="${CMANGOS_UPSTREAM_BRANCH:-master}"
CHECK_ONLY=false
UPDATE_SUBMODULES=true

usage()
{
    cat <<EOF
Usage: $0 [--check] [--no-submodules] [--db-path PATH]

Updates the current custom branches of mangos-tbc and tbc-db from the
official CMaNGOS upstream repositories. Nothing is pushed automatically.

Options:
  --check             Fetch and report available commits without merging.
  --no-submodules     Do not update Core Git submodules after the merge.
  --db-path PATH      Override the default sibling tbc-db directory.
  -h, --help          Show this help.
EOF
}

while (($#)); do
    case "$1" in
        --check)
            CHECK_ONLY=true
            ;;
        --no-submodules)
            UPDATE_SUBMODULES=false
            ;;
        --db-path)
            [[ $# -ge 2 ]] || { echo "--db-path requires a path" >&2; exit 2; }
            DB_PATH="$2"
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 2
            ;;
    esac
    shift
done

require_command()
{
    command -v "$1" >/dev/null 2>&1 || { echo "Required command not found: $1" >&2; exit 1; }
}

verify_repository()
{
    local label="$1"
    local path="$2"

    [[ -d "$path/.git" ]] || {
        echo "$label repository not found: $path" >&2
        exit 1
    }

    if [[ -n "$(git -C "$path" status --porcelain)" ]]; then
        echo "$label has uncommitted changes; commit or stash them first: $path" >&2
        exit 1
    fi
}

prepare_upstream()
{
    local path="$1"
    local url="$2"

    if git -C "$path" remote get-url upstream >/dev/null 2>&1; then
        git -C "$path" remote set-url upstream "$url"
    else
        git -C "$path" remote add upstream "$url"
    fi
}

fetch_repository()
{
    local label="$1"
    local path="$2"
    local url="$3"

    echo "==> Fetching $label"
    prepare_upstream "$path" "$url"
    git -C "$path" fetch --prune upstream
    if git -C "$path" remote get-url origin >/dev/null 2>&1; then
        git -C "$path" fetch --prune origin
    fi

    local counts
    counts="$(git -C "$path" rev-list --left-right --count "HEAD...upstream/$UPSTREAM_BRANCH")"
    echo "    Current branch: $(git -C "$path" branch --show-current)"
    echo "    Local-only / upstream-only commits: $counts"
}

sync_origin()
{
    local label="$1"
    local path="$2"
    local branch
    branch="$(git -C "$path" branch --show-current)"

    [[ -n "$branch" ]] || {
        echo "$label is in detached HEAD state; check out a branch first." >&2
        exit 1
    }

    if git -C "$path" show-ref --verify --quiet "refs/remotes/origin/$branch"; then
        echo "==> Synchronizing $label with origin/$branch"
        if ! git -C "$path" merge --ff-only "origin/$branch"; then
            echo "$label and origin/$branch have diverged." >&2
            echo "Reconcile or push the local commits manually, then run this script again." >&2
            exit 1
        fi
    else
        echo "==> No origin/$branch branch found for $label; keeping the local branch"
    fi
}

merge_repository()
{
    local label="$1"
    local path="$2"

    if git -C "$path" merge-base --is-ancestor "upstream/$UPSTREAM_BRANCH" HEAD; then
        echo "==> $label is already up to date"
        return
    fi

    echo "==> Merging official upstream into $label"
    if ! git -C "$path" merge --no-edit "upstream/$UPSTREAM_BRANCH"; then
        echo >&2
        echo "Merge conflict in $label. Resolve the files and run 'git commit'," >&2
        echo "or cancel with: git -C '$path' merge --abort" >&2
        exit 1
    fi
}

require_command git
verify_repository "Core" "$CORE_PATH"
verify_repository "TBC-DB" "$DB_PATH"

echo "Core:   $CORE_PATH"
echo "TBC-DB: $DB_PATH"
fetch_repository "Core" "$CORE_PATH" "$CORE_UPSTREAM_URL"
fetch_repository "TBC-DB" "$DB_PATH" "$DB_UPSTREAM_URL"

if [[ "$CHECK_ONLY" == "true" ]]; then
    echo "Check completed; no local branches were changed."
    exit 0
fi

STAMP="$(date -u '+%Y%m%d-%H%M%S')"
BACKUP_TAG="backup/before-update-$STAMP"
git -C "$CORE_PATH" tag "$BACKUP_TAG"
git -C "$DB_PATH" tag "$BACKUP_TAG"
echo "Created local backup tag in both repositories: $BACKUP_TAG"

sync_origin "Core" "$CORE_PATH"
sync_origin "TBC-DB" "$DB_PATH"
merge_repository "Core" "$CORE_PATH"
merge_repository "TBC-DB" "$DB_PATH"

if [[ "$UPDATE_SUBMODULES" == "true" ]]; then
    echo "==> Synchronizing Core submodules"
    git -C "$CORE_PATH" submodule sync --recursive
    git -C "$CORE_PATH" submodule update --init --recursive
fi

echo
echo "Update completed successfully. Review and compile the Core before pushing."
echo "Core:   $(git -C "$CORE_PATH" log -1 --oneline)"
echo "TBC-DB: $(git -C "$DB_PATH" log -1 --oneline)"
