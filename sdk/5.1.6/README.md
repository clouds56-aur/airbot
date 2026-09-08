# Legacy SDK: 5.1.6

Use airbot_py with the legacy 5.1.6 runtime. It exposes a different API from
arm_sdk 5.2.2, so this repository installs it in a separate user environment.

The SDK pins gRPC 1.70, which has no CPython 3.14 wheel. The
[airbot-sdk-5.1 package](../../packages/airbot-sdk-5.1/README.md) installs
Python 3.12, the vendor wheel, and the complete pinned dependency set:

~~~bash
./packages/airbot-sdk-5.1/install.sh /path/to/airbot_py-5.1.6-py3-none-any.whl
~~~

The wheel argument is optional. Supplying it avoids downloading the large
vendor archive.

Dependency validation, AIRBOTPlay import, Protobuf schema import, and CLI help
passed with Python 3.12.14. No robot connection is made by the help command:

~~~bash
arm_joint_state-5.1 --help
airbot-python-5.1 -c 'from importlib.metadata import version; print(version("airbot-py"))'
~~~

The wheel's distribution metadata identifies 5.1.6, while its
airbot_py.__version__ constant is stale at 5.0.0. Use distribution metadata
when checking the installed version.

See [legacy runtime and CAN configuration](../../docs/legacy-5.1.6.md).
