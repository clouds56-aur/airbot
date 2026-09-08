# Legacy release 5.1.6

The original workflow consists of a host configuration package, a containerized
controller runtime, and the matching Python or C++ client SDK.

## Host configuration

The vendor's
[airbot-configure_5.1.6-1_all.deb](https://docs.airbots.online/assets/airbot-play/5.1.6/airbot-configure_5.1.6-1_all.deb)
contains CAN setup scripts, udev rules, a SLCAN systemd service, device-name
helpers, and container launchers. It is not the controller binary or SDK.

Recorded SHA-256:

~~~text
412658af9abffd4b5157f303b96af64d591c5abd43ae73b3e00b485de4ff7207
~~~

The Arch recipe extracts that payload and adapts these details:

- Ubuntu's dialout group and mode 0777 become uucp and mode 0660.
- Package-owned files move from /usr/local/bin to /usr/bin or
  /usr/lib/airbot-configure.
- Shell arguments and volume paths are quoted.
- The malformed device-binding helper is replaced with a reviewed helper.
- Debian maintainer scripts are not executed.

Build it with:

~~~bash
cd packages/airbot-configure
makepkg
sudo pacman -U airbot-configure-5.1.6-1-any.pkg.tar.zst
~~~

## Controller runtime

The airbot_server alias invokes airbot_fsm, which launches:

~~~text
registry.cn-shanghai.aliyuncs.com/discover-robotics/airbot-runtime:5.1.6
~~~

The vendor script runs ros2 run fsm fsm_node inside that image with host
networking. The registry manifest includes Linux amd64 and arm64 builds.
Podman can access the manifest on the tested Arch host; the container has not
yet been run through a controller startup test.

The firmware-upgrade launcher uses the same runtime image. Firmware upgrades
are separate from installing host software and were not performed.

## CAN adapter setup

The package recognizes native USB CAN (1d50:606f) and serial CAN (0483:0000).
The latter uses slcan and slcand. Identify the connected adapter before choosing
its setup.

The vendor scripts specify 1 Mbit/s CAN and, for the serial adapter, 3,000,000
baud. Those settings were inspected but have not been tested with a connected
arm. can-utils comes from the existing AUR package.

## Client SDK

Follow the [legacy SDK package](../packages/airbot-sdk-5.1/README.md). It
installs the SDK and pinned dependencies in the current user's data directory:

~~~bash
./packages/airbot-sdk-5.1/install.sh
~~~

The archive also contains Ubuntu C++ packages named airbot_cpp; their package
metadata identifies airbotsdk=5.1.6. They provide a C++ client, not a controller
service.
