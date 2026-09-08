#!/usr/bin/env bash
set -euo pipefail

package_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
export AIRBOT_PACKAGE_NAME=airbot-sdk-5.1
export AIRBOT_SDK_VERSION=5.1.6
export AIRBOT_PYTHON_VERSION=3.12
export AIRBOT_DISTRIBUTION=airbot-py
export AIRBOT_ARCHIVE_NAME=5.1.6.zip
export AIRBOT_ARCHIVE_URL=https://docs.airbots.online/assets/airbot-play/5.1.6/5.1.6.zip
export AIRBOT_ARCHIVE_SHA256=9c1e657645a169d0cb11269186798c681f6a05a0aaecc60d5707d2041c2f6f73
export AIRBOT_ARCHIVE_FORMAT=zip
export AIRBOT_WHEEL_MEMBER=5.1.6/airbot_py-5.1.6-py3-none-any.whl
export AIRBOT_WHEEL_NAME=airbot_py-5.1.6-py3-none-any.whl
export AIRBOT_WHEEL_SHA256=ca364deb444f40eddb9933e42dab96587727802f918744bfff698e132e453408
export AIRBOT_COMMAND_SUFFIX=5.1
export AIRBOT_ENTRYPOINTS='arm_end_pose arm_example_swing arm_example_wipe arm_follow arm_get_params arm_joint_state arm_kbd_ctrl arm_load_app arm_move_cart_pose arm_move_cart_waypoints arm_move_joint arm_move_joint_waypoints arm_set_params arm_switch_mode arm_unload_app'

exec "$package_dir/../../scripts/install-user-sdk.sh" "$package_dir/constraints.txt" "$@"
