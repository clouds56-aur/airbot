# Legacy SDK: 5.1.6

Use `airbot_py` with the legacy 5.1.6 runtime. It exposes a different API from
`arm_sdk` 5.2.2. Keep the environments separate.

The SDK pins gRPC 1.70, which has no CPython 3.14 wheel. Python 3.12 was tested.
The following commands run from the repository root and require `uv`, `curl`,
and `unzip`.

```bash
mkdir -p downloads
curl --fail --location --output downloads/airbot-sdk-5.1.6.zip \
  https://docs.airbots.online/assets/airbot-play/5.1.6/5.1.6.zip
printf '%s  %s\n' \
  9c1e657645a169d0cb11269186798c681f6a05a0aaecc60d5707d2041c2f6f73 \
  downloads/airbot-sdk-5.1.6.zip | sha256sum -c -
unzip -o downloads/airbot-sdk-5.1.6.zip \
  '5.1.6/airbot_py-5.1.6-py3-none-any.whl' -d downloads
uv venv --python 3.12 .venv-5.1.6
uv pip install --python .venv-5.1.6/bin/python \
  -c sdk/5.1.6/constraints.txt \
  downloads/5.1.6/airbot_py-5.1.6-py3-none-any.whl
.venv-5.1.6/bin/arm_joint_state --help
```

Dependency validation, `AIRBOTPlay` import, Protobuf schema import, and CLI help
passed with Python 3.12.14. No robot connection is made by the help command.

The wheel's distribution metadata identifies 5.1.6, while its
`airbot_py.__version__` constant is stale at 5.0.0. Query the installed metadata:

```bash
.venv-5.1.6/bin/python -c \
  'from importlib.metadata import version; print(version("airbot-py"))'
```

See [legacy runtime and CAN configuration](../../docs/legacy-5.1.6.md).
