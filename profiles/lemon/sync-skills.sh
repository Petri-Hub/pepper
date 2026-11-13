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

# Every folder in skills/ is repository-managed and replaced; skills that exist
# only in the destination stay intact.
names=
for dir in "$source_dir"/*/; do
    name=$(basename "$dir")
    if [ ! -f "$source_dir/$name/SKILL.md" ] || [ -L "$target_dir/$name" ]; then
        echo "Invalid source or symlink destination for $name." >&2
        exit 1
    fi
    names="$names $name"
done

# Move the former managed skill before syncing its replacement.
if [ -e "$target_dir/model" ] || [ -L "$target_dir/model" ]; then
    if [ -L "$target_dir/model" ] || [ ! -f "$target_dir/model/SKILL.md" ] \
        || ! grep -qx 'name: model' "$target_dir/model/SKILL.md" \
        || ! grep -qx '# Make a 3D asset work in Roblox' "$target_dir/model/SKILL.md" \
        || [ -e "$target_dir/modelling" ]; then
        echo "Cannot safely migrate the old model skill; inspect the destination first." >&2
        exit 1
    fi
    mv "$target_dir/model" "$target_dir/modelling"
fi

for name in $names; do
    mkdir -p "$target_dir/$name"
    rsync -a --no-owner --no-group --delete "$source_dir/$name/" "$target_dir/$name/"
    printf 'Replaced %s\n' "$name"
done
