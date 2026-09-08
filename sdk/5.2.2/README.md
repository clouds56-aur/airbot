# Current SDK: 5.2.2

Use `arm_sdk` with the matching 5.2.2 controller. The commands below run from
the repository root and require `uv`, `curl`, and `tar`.

```bash
mkdir -p downloads
curl --fail --location \
  --output downloads/sdk_client_release.tar.gz \
  https://docs.airbots.online/assets/airbot-play/5.2/sdk_client_release.tar.gz
printf '%s  %s\n' \
  136b11efcf3edc3a3d8647994690ee929b9fd6547cdacb0796b706393b0a92ff \
  downloads/sdk_client_release.tar.gz | sha256sum -c -
tar -xzf downloads/sdk_client_release.tar.gz -C downloads \
  dist/x86_64/arm_sdk-5.2.2-py3-none-any.whl
uv venv --python 3.14 .venv-5.2.2
uv pip install --python .venv-5.2.2/bin/python \
  -c sdk/5.2.2/constraints.txt \
  downloads/dist/x86_64/arm_sdk-5.2.2-py3-none-any.whl
.venv-5.2.2/bin/arm-sdk version
.venv-5.2.2/bin/arm-sdk examples list
```

Installation, imports, example listing, and Protobuf serialization passed with
Python 3.14.7. The constraints preserve that tested dependency set.

The generated SDK code requires gRPC 1.80+ and Protobuf 6.31.1+, although its
metadata declares lower minimums. The tested environment uses grpcio 1.83.1 and
protobuf 7.36.1.
