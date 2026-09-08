#!/usr/bin/env bash
set -euo pipefail

package_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
export AIRBOT_PACKAGE_NAME=airbot-sdk-5.2
export AIRBOT_SDK_VERSION=5.2.2
export AIRBOT_PYTHON_VERSION=3.14
export AIRBOT_DISTRIBUTION=arm-sdk
export AIRBOT_ARCHIVE_NAME=sdk_client_release.tar.gz
export AIRBOT_ARCHIVE_URL=https://docs.airbots.online/assets/airbot-play/5.2/sdk_client_release.tar.gz
export AIRBOT_ARCHIVE_SHA256=136b11efcf3edc3a3d8647994690ee929b9fd6547cdacb0796b706393b0a92ff
export AIRBOT_ARCHIVE_FORMAT=tar.gz
export AIRBOT_WHEEL_MEMBER=dist/x86_64/arm_sdk-5.2.2-py3-none-any.whl
export AIRBOT_WHEEL_NAME=arm_sdk-5.2.2-py3-none-any.whl
export AIRBOT_WHEEL_SHA256=4b22d7f0df396e93ec66304754a6bdfcb877d074bc2cbb18aee313f2c7c56c11
export AIRBOT_COMMAND_SUFFIX=5.2
export AIRBOT_ENTRYPOINTS=arm-sdk

exec "$package_dir/../../scripts/install-user-sdk.sh" "$package_dir/constraints.txt" "$@"
