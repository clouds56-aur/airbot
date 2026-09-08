# airbot-arm-bin 5.2.2

Packages the vendor's Ubuntu 22.04 x86_64 controller for Arch Linux. The vendor
archive also contains other builds; this recipe selects only the tested one.

The download is approximately 664 MiB. To reuse a previously downloaded copy,
place it beside `PKGBUILD` as `airbot-arm-release-5.2.2.tar.gz`. Its hash must match
the recipe.

```bash
makepkg
sudo pacman -U airbot-arm-bin-5.2.2-1-x86_64.pkg.tar.zst
airbot-arm --help
```

Install `can-utils` through its existing AUR package before building. Other
dependencies are `glibc`, `libcap`, and `iproute2`.

The package installs `/usr/bin/airbot-arm` and
`/usr/share/airbot_controllers`. It preserves the vendor executable without
stripping and includes no service-start hooks or USB configuration rules.

The executable's `--version` reports `1.0` despite Debian package metadata
identifying release 5.2.2. Use `pacman -Q airbot-arm-bin` to identify the package.

The upstream binary package contains no license text. `LicenseRef-Unknown`
records that fact; it does not assign the Python SDK's license to the controller.
