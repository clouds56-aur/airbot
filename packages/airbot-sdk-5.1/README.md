# airbot-sdk-5.1

User-space installation for the legacy AIRBOT Python SDK 5.1.6. The installed
environment contains Python 3.12, airbot_py, and the complete pinned dependency
set. It does not require root access and can coexist with airbot-sdk-5.2.

Install from an already extracted wheel:

~~~bash
./packages/airbot-sdk-5.1/install.sh /path/to/airbot_py-5.1.6-py3-none-any.whl
~~~

Without a wheel argument, the installer downloads the verified vendor 5.1.6
archive and extracts the wheel. Supplying the wheel avoids downloading the much
larger archive.

The environment is installed under:

~~~text
${AIRBOT_SDK_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/airbot-sdk}/5.1.6
~~~

Use it by activating the environment or through the versioned commands:

~~~bash
source ~/.local/share/airbot-sdk/5.1.6/bin/activate
airbot-python-5.1 your_program.py
arm_joint_state-5.1 --help
~~~
