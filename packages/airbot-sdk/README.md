# airbot-sdk

This package installs a small manager for the two tested AIRBOT Python SDK
releases. Each release uses its own uv-managed Python interpreter and virtual
environment under:

~~~text
${XDG_DATA_HOME:-$HOME/.local/share}/airbot-sdk/<version>
~~~

Build the manager:

~~~bash
cd packages/airbot-sdk
makepkg
sudo pacman -U airbot-sdk-0.1.0-1-any.pkg.tar.zst
~~~

Install and use both SDKs:

~~~bash
airbot-sdk install 5.1.6
airbot-sdk install 5.2.2
airbot-sdk list
airbot-sdk run 5.1.6 arm_joint_state --help
airbot-sdk run 5.2.2 arm-sdk version
airbot-sdk python 5.1.6 -c 'from importlib.metadata import version; print(version("airbot-py"))'
~~~

The 5.1.6 environment uses Python 3.12; the 5.2.2 environment uses Python
3.14. Downloads are checked against the hashes recorded from the vendor
archives. If a wheel is already extracted, pass its path as the third argument
to avoid downloading the full vendor archive:

~~~bash
airbot-sdk install 5.1.6 /path/to/airbot_py-5.1.6-py3-none-any.whl
~~~

The supplied wheel is also checked against its recorded SHA-256. Set
AIRBOT_SDK_HOME to store the versioned environments elsewhere.
