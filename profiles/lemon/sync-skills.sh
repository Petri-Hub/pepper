#!/bin/sh
set -eu

if [ "$#" -ne 1 ] || [ ! -d "$1" ]; then
    echo "Usage: $0 <existing-lemon-profile-skills-directory>" >&2
    exit 1
fi

source_dir=$(CDPATH= cd -- "$(dirname -- "$0")/skills" && pwd -P)
target_dir=$(CDPATH= cd -- "$1" && pwd -P)

if [ "$source_dir" = "$target_dir" ]; then
    echo "Source and destination must be different directories." >&2
    exit 1
fi

# Only these repository-managed skills are replaced; other skills stay intact.
for name in assets-search assets-answering onboarding controls deliver design document implement install model-3d plan serve test; do
    if [ ! -f "$source_dir/$name/SKILL.md" ] || [ -L "$target_dir/$name" ]; then
        echo "Invalid source or symlink destination for $name." >&2
        exit 1
    fi
done

for name in assets-search assets-answering onboarding controls deliver design document implement install model-3d plan serve test; do
    mkdir -p "$target_dir/$name"
    rsync -a --no-owner --no-group --delete "$source_dir/$name/" "$target_dir/$name/"
    printf 'Replaced %s\n' "$name"
done
