# AIRBOT for Arch Linux

AIRBOT package recipes, SDK environments, and compatibility notes maintained in
one repository.

| Release | Components | Location |
| --- | --- | --- |
| Current: 5.2.2 | Native controller package and Python SDK | [Controller](packages/airbot-arm-bin/README.md), [SDK](sdk/5.2.2/README.md) |
| Legacy: 5.1.6 | Container runtime, Python SDK, and configuration notes | [Legacy setup](docs/legacy-5.1.6.md), [SDK](sdk/5.1.6/README.md) |

Use matching controller and SDK versions. Motor firmware compatibility is a
separate requirement; consult the vendor's
[firmware guidance](https://docs.airbots.online/airbot-play/sdk/quickstart/motor-version.html)
when changing releases.

## Repository layout

```text
packages/airbot-arm-bin/  Arch controller recipe and AUR metadata
sdk/5.2.2/               Current Python SDK setup and tested constraints
sdk/5.1.6/               Legacy Python SDK setup and tested constraints
docs/                   Compatibility results and legacy configuration notes
scripts/check.sh         Recipe syntax and .SRCINFO validation
```

`can-utils` is an external dependency. Use the existing
[AUR package](https://aur.archlinux.org/packages/can-utils); this repository does
not maintain a copy of its recipe.

## Current controller

With `base-devel` and the runtime dependencies installed on x86_64 Arch:

```bash
cd packages/airbot-arm-bin
makepkg
sudo pacman -U airbot-arm-bin-5.2.2-1-x86_64.pkg.tar.zst
airbot-arm --help
```

The recipe downloads the vendor release archive, verifies its SHA-256, and
extracts the Ubuntu 22.04 x86_64 payload into an Arch package. Installation does
not start a controller service or configure a connected arm.

See [compatibility results](docs/arch-compatibility.md) for what has been tested.

## Development

Use two-space indentation. Keep `.SRCINFO` synchronized with each `PKGBUILD`:

```bash
cd packages/airbot-arm-bin
makepkg --printsrcinfo > .SRCINFO
```

Run `bash scripts/check.sh` from the repository root on Arch Linux as a non-root
user. CI runs the same checks. It does not operate hardware or publish binaries.

This GitHub monorepo is the source workspace. Creating it does not publish or
update an AUR package. Vendor downloads, built packages, logs, and local virtual
environments are excluded from Git.
