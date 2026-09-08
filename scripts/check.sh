#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
command -v makepkg >/dev/null || {
  printf 'Run this check on Arch Linux with makepkg installed.\n' >&2
  exit 1
}

check_dir=$(mktemp -d)
trap 'rm -rf -- "$check_dir"' EXIT

bash -n "$repo_root/scripts/check.sh"
for package_dir in "$repo_root"/packages/*; do
  [[ -f "$package_dir/PKGBUILD" ]] || continue
  bash -n "$package_dir/PKGBUILD"
  (cd "$package_dir" && makepkg --printsrcinfo) > "$check_dir/SRCINFO"
  diff -u "$package_dir/.SRCINFO" "$check_dir/SRCINFO"
  printf 'Checked %s\n' "${package_dir##*/}"
done
