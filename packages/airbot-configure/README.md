# airbot-configure

This recipe downloads and extracts the vendor
airbot-configure_5.1.6-1_all.deb package. It packages the vendor's runtime
launchers, CAN helpers, udev rules, and SLCAN service after applying the small
changes needed on Arch Linux.

The recipe changes package-owned paths from /usr/local to /usr, uses the Arch
uucp group with mode 0660, quotes shell arguments, and uses /usr/bin/ip. The
vendor device-binding helper has invalid shell tests and writes executable udev
rules, so the recipe replaces only that helper with a reviewed implementation.

The package depends on podman-docker. The legacy launchers keep using the
vendor's docker command, which Podman provides on Arch. The runtime image is
downloaded only when airbot_fsm or airbot_iap is run.

Build and install:

~~~bash
cd packages/airbot-configure
makepkg
sudo pacman -U airbot-configure-5.1.6-1-any.pkg.tar.zst
~~~

After connecting the adapter, find its USB serial and create a stable interface
name:

~~~bash
sudo bind_airbot_device slcan SERIAL_VALUE can_left
sudo bind_airbot_device can SERIAL_VALUE can_left
~~~

Remove generated rules with sudo bind_airbot_device rm. The base automatic
rules remain owned by the package.

can-utils remains an external AUR dependency and is not maintained here.
