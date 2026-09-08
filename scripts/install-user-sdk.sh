#!/usr/bin/env bash
set -euo pipefail

lock_file=${1:?dependency lock file is required}
shift
supplied_wheel=${1:-}
[[ $# -le 1 ]] || {
  printf 'Usage: install.sh [vendor-wheel]\n' >&2
  exit 2
}

required_vars=(AIRBOT_PACKAGE_NAME AIRBOT_SDK_VERSION AIRBOT_PYTHON_VERSION AIRBOT_DISTRIBUTION AIRBOT_ARCHIVE_NAME AIRBOT_ARCHIVE_URL AIRBOT_ARCHIVE_SHA256 AIRBOT_ARCHIVE_FORMAT AIRBOT_WHEEL_MEMBER AIRBOT_WHEEL_NAME AIRBOT_WHEEL_SHA256 AIRBOT_COMMAND_SUFFIX AIRBOT_ENTRYPOINTS)
for variable_name in "${required_vars[@]}"; do
  [[ -n ${!variable_name:-} ]] || {
    printf 'Missing installer configuration: %s\n' "$variable_name" >&2
    exit 1
  }
done

[[ -f $lock_file ]] || {
  printf 'Dependency lock file does not exist: %s\n' "$lock_file" >&2
  exit 1
}
command -v uv >/dev/null || {
  printf 'uv is required. Install it for your user, then rerun this installer.\n' >&2
  exit 1
}
command -v sha256sum >/dev/null || {
  printf 'sha256sum is required.\n' >&2
  exit 1
}

data_root=${AIRBOT_SDK_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/airbot-sdk}
bin_root=${XDG_BIN_HOME:-$HOME/.local/bin}
version_root=$data_root/$AIRBOT_SDK_VERSION
download_root=$data_root/downloads
archive_path=$download_root/$AIRBOT_ARCHIVE_NAME
partial_path=$archive_path.part
wheel_path=
staging_root=

cleanup() {
  [[ -z $staging_root ]] || rm -rf "$staging_root"
}
trap cleanup EXIT

verify_file() {
  printf '%s  %s\n' "$1" "$2" | sha256sum --check --status
}

mkdir -p "$data_root" "$download_root" "$bin_root"

if [[ -n $supplied_wheel ]]; then
  wheel_path=$supplied_wheel
  [[ -f $wheel_path ]] || {
    printf 'Wheel file does not exist: %s\n' "$wheel_path" >&2
    exit 1
  }
else
  command -v curl >/dev/null || {
    printf 'curl is required when no local wheel is supplied.\n' >&2
    exit 1
  }
  if [[ ! -f $archive_path ]] || ! verify_file "$AIRBOT_ARCHIVE_SHA256" "$archive_path"; then
    rm -f "$partial_path"
    curl --fail --location --output "$partial_path" "$AIRBOT_ARCHIVE_URL"
    verify_file "$AIRBOT_ARCHIVE_SHA256" "$partial_path" || {
      printf 'Archive checksum verification failed.\n' >&2
      rm -f "$partial_path"
      exit 1
    }
    mv "$partial_path" "$archive_path"
  fi

  wheel_path=$download_root/$AIRBOT_WHEEL_NAME
  case $AIRBOT_ARCHIVE_FORMAT in
    zip)
      command -v unzip >/dev/null || {
        printf 'unzip is required for this release.\n' >&2
        exit 1
      }
      unzip -p "$archive_path" "$AIRBOT_WHEEL_MEMBER" > "$wheel_path"
      ;;
    tar.gz)
      command -v tar >/dev/null || {
        printf 'tar is required for this release.\n' >&2
        exit 1
      }
      tar -xOzf "$archive_path" "$AIRBOT_WHEEL_MEMBER" > "$wheel_path"
      ;;
    *)
      printf 'Unsupported archive format: %s\n' "$AIRBOT_ARCHIVE_FORMAT" >&2
      exit 1
      ;;
  esac
fi

verify_file "$AIRBOT_WHEEL_SHA256" "$wheel_path" || {
  printf 'Wheel checksum verification failed: %s\n' "$wheel_path" >&2
  exit 1
}

uv python install "$AIRBOT_PYTHON_VERSION"
staging_root=$(mktemp -d "$data_root/.${AIRBOT_SDK_VERSION}.XXXXXX")
uv venv --relocatable --python "$AIRBOT_PYTHON_VERSION" "$staging_root"
uv pip install --python "$staging_root/bin/python" --constraint "$lock_file" "$wheel_path"

actual_version=$("$staging_root/bin/python" -c 'import importlib.metadata, sys; print(importlib.metadata.version(sys.argv[1]))' "$AIRBOT_DISTRIBUTION")
[[ $actual_version == "$AIRBOT_SDK_VERSION" ]] || {
  printf 'Installed %s %s, expected %s.\n' "$AIRBOT_DISTRIBUTION" "$actual_version" "$AIRBOT_SDK_VERSION" >&2
  exit 1
}

read -r -a entrypoints <<< "$AIRBOT_ENTRYPOINTS"
for entrypoint in "${entrypoints[@]}"; do
  [[ -x $staging_root/bin/$entrypoint ]] || {
    printf 'Expected SDK command is missing: %s\n' "$entrypoint" >&2
    exit 1
  }
done

rm -rf "$version_root"
mv "$staging_root" "$version_root"
staging_root=

python_command=$bin_root/airbot-python-$AIRBOT_COMMAND_SUFFIX
rm -f "$python_command"
printf '#!/usr/bin/env bash\nexec %q "$@"\n' "$version_root/bin/python" > "$python_command"
chmod 0755 "$python_command"
for entrypoint in "${entrypoints[@]}"; do
  ln -sfn "$version_root/bin/$entrypoint" "$bin_root/$entrypoint-$AIRBOT_COMMAND_SUFFIX"
done

printf 'Installed %s in %s\n' "$AIRBOT_PACKAGE_NAME" "$version_root"
printf 'Activate with: source %s/bin/activate\n' "$version_root"
printf 'Versioned Python: %s/airbot-python-%s\n' "$bin_root" "$AIRBOT_COMMAND_SUFFIX"
case :$PATH: in
  *:$bin_root:*) ;;
  *) printf 'Add %s to PATH to use the versioned commands directly.\n' "$bin_root" ;;
esac
