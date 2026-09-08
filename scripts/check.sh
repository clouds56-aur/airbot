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
  while IFS= read -r script; do
    if head -n 1 "$script" | grep -Eq '^#!.*(ba)?sh'; then
      bash -n "$script"
    fi
  done < <(find "$package_dir" -maxdepth 1 -type f -not -name PKGBUILD -print | sort)
  (cd "$package_dir" && makepkg --printsrcinfo) > "$check_dir/SRCINFO"
  diff -u "$package_dir/.SRCINFO" "$check_dir/SRCINFO"
  printf 'Checked %s\n' "${package_dir##*/}"
done

diff -u "$repo_root/sdk/5.1.6/constraints.txt" "$repo_root/packages/airbot-sdk/constraints-5.1.6.txt"
diff -u "$repo_root/sdk/5.2.2/constraints.txt" "$repo_root/packages/airbot-sdk/constraints-5.2.2.txt"

if [[ -d "$repo_root/packages/can-utils" ]]; then
  printf 'can-utils must remain an external dependency.\n' >&2
  exit 1
fi
