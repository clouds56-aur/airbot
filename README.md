# AIRBOT for Arch Linux

AIRBOT package recipes, SDK environments, and compatibility notes maintained in
one repository.

| Release | Components | Location |
| --- | --- | --- |
| Current: 5.2.2 | Native controller package and Python SDK | [Controller](packages/airbot-arm-bin/README.md), [SDK](sdk/5.2.2/README.md) |
| Legacy: 5.1.6 | Host configuration, container runtime, and Python SDK | [Configuration](packages/airbot-configure/README.md), [SDK](sdk/5.1.6/README.md) |

Use matching controller and SDK versions. Motor firmware compatibility is a
separate requirement; consult the vendor's
[firmware guidance](https://docs.airbots.online/airbot-play/sdk/quickstart/motor-version.html)
when changing releases.

## Repository layout

~~~text
packages/airbot-arm-bin/    Arch controller recipe and AUR metadata
packages/airbot-configure/  Legacy 5.1.6 host integration recipe
packages/airbot-sdk-5.1/    Legacy user-space SDK package
packages/airbot-sdk-5.2/    Current user-space SDK package
sdk/5.2.2/                  Current Python SDK setup and tested constraints
sdk/5.1.6/                  Legacy Python SDK setup and tested constraints
docs/                       Compatibility results and legacy configuration notes
scripts/check.sh            Recipe syntax and .SRCINFO validation
~~~

can-utils is an external dependency. Use the existing
[AUR package](https://aur.archlinux.org/packages/can-utils); this repository does
not maintain a copy of its recipe.

## Current controller

With base-devel and the runtime dependencies installed on x86_64 Arch:

~~~bash
cd packages/airbot-arm-bin
makepkg
sudo pacman -U airbot-arm-bin-5.2.2-1-x86_64.pkg.tar.zst
airbot-arm --help
~~~

The recipe downloads the vendor release archive, verifies its SHA-256, and
extracts the Ubuntu 22.04 x86_64 payload into an Arch package. Installation does
not start a controller service or configure a connected arm.

See [compatibility results](docs/arch-compatibility.md) for what has been tested.

## Legacy configuration and SDKs

The old 5.1.6 controller uses the vendor runtime container and needs the
matching host CAN/SLCAN setup:

~~~bash
cd packages/airbot-configure
makepkg
sudo pacman -U airbot-configure-5.1.6-1-any.pkg.tar.zst
~~~

The recipe extracts the verified Debian package and adapts its paths, udev
permissions, and shell quoting for Arch. It does not execute Debian maintainer
scripts.

Install both Python SDK packages in user space. These commands do not use sudo:

~~~bash
./packages/airbot-sdk-5.1/install.sh
./packages/airbot-sdk-5.2/install.sh
arm_joint_state-5.1 --help
arm-sdk-5.2 version
~~~

Each package installs a complete pinned environment under the current user's
data directory. The legacy package uses Python 3.12 because its gRPC dependency
has no Python 3.14 wheel; the current package uses Python 3.14. The installers
require uv but do not require a system Python package.

## Development

Use two-space indentation. Keep .SRCINFO synchronized with each PKGBUILD:

~~~bash
cd packages/airbot-arm-bin
makepkg --printsrcinfo > .SRCINFO
~~~

Run bash scripts/check.sh from the repository root on Arch Linux as a non-root
user. CI runs the same checks. It does not operate hardware or publish binaries.

This GitHub monorepo is the source workspace. Creating it does not publish or
update an AUR package. Vendor downloads, built packages, logs, and local virtual
environments are excluded from Git.
