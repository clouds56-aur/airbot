# Current SDK: 5.2.2

Use arm_sdk with the matching 5.2.2 controller. The
[airbot-sdk-5.2 package](../../packages/airbot-sdk-5.2/README.md) installs
Python 3.14, the vendor wheel, and the complete pinned dependency set in user
space:

~~~bash
./packages/airbot-sdk-5.2/install.sh /path/to/arm_sdk-5.2.2-py3-none-any.whl
~~~

The wheel argument is optional. Without it, the installer downloads and
verifies the vendor SDK archive.

Installation, imports, example listing, and Protobuf serialization passed with
Python 3.14.7:

~~~bash
arm-sdk-5.2 version
arm-sdk-5.2 examples list
~~~

The generated SDK code requires gRPC 1.80+ and Protobuf 6.31.1+, although its
metadata declares lower minimums. The pinned environment uses grpcio 1.83.1 and
protobuf 7.36.1.
