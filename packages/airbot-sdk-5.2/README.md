# airbot-sdk-5.2

User-space installation for the current AIRBOT Python SDK 5.2.2. The installed
environment contains Python 3.14, arm_sdk, and the complete pinned dependency
set. It does not require root access and can coexist with airbot-sdk-5.1.

Install from an already extracted wheel:

~~~bash
./packages/airbot-sdk-5.2/install.sh /path/to/arm_sdk-5.2.2-py3-none-any.whl
~~~

Without a wheel argument, the installer downloads and verifies the vendor SDK
archive before extracting the wheel.

The environment is installed under:

~~~text
${AIRBOT_SDK_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/airbot-sdk}/5.2.2
~~~

Use it by activating the environment or through the versioned commands:

~~~bash
source ~/.local/share/airbot-sdk/5.2.2/bin/activate
airbot-python-5.2 your_program.py
arm-sdk-5.2 version
~~~
