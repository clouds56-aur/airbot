# Arch Linux compatibility

Software checks performed on 2026-09-08 using x86_64 Arch Linux, kernel
7.2.2-arch1-1, and glibc 2.44. The vendor documents Ubuntu 20.04 or newer.

| Component | Verified result |
| --- | --- |
| Linux CAN | `slcan`, `gs_usb`, and `can_raw` modules available; CAN_RAW socket creation succeeds |
| Current controller 5.2.2 | Ubuntu 22.04 x86_64 binary loads natively and prints help |
| Controller dependencies | libcap, libm, libc, and ELF loader all resolve; highest required glibc version is 2.34 |
| Current SDK 5.2.2 | Installation, imports, CLI, and Protobuf round trip pass on Python 3.14.7 |
| Legacy SDK 5.1.6 | Installation, dependency validation, imports, and CLI help pass on Python 3.12.14 |
| Legacy runtime image | Vendor manifest includes Linux amd64 and arm64; container execution remains untested |

A 5.2.2 controller probe against a deliberately nonexistent CAN interface reached
SocketCAN initialization, then aborted because the arm base board was absent.
That establishes executable loading, not a successful controller startup.
Physical control, firmware compatibility, cameras, simulation, and real-time
reliability remain unverified.

The current native binary does not dynamically depend on the host's Boost,
Protobuf, gRPC, or C++ standard library. It hard-codes
`/usr/share/airbot_controllers`, so the Arch package preserves that resource path.
All vendor payload files passed the Debian package's embedded MD5 checks.

An unprivileged startup probe reported unsuccessful FIFO scheduling and memory
locking. The vendor instructs running the controller with sudo; the software
checks do not establish real-time behavior under those privileges.

The current and legacy SDKs use different APIs and dependency versions. Their
separate constraint files record versions actually tested. Software release
numbers do not identify individual motor firmware versions. The vendor's
current migration guidance requires OD firmware 04114 or newer and DM firmware
5015, and explicitly asks users of 5.1.6 software to verify DM firmware.

## Sources

- [Installation requirements](https://docs.airbots.online/airbot-play/sdk/quickstart/installation.html)
- [Release history](https://docs.airbots.online/airbot-play/changelog.html)
- [Firmware compatibility](https://docs.airbots.online/airbot-play/sdk/quickstart/motor-version.html)
- [Controller startup](https://docs.airbots.online/airbot-play/sdk/quickstart/run-service.html)
- [Linux SocketCAN](https://docs.kernel.org/networking/can.html)

The SHA-256 values in the recipes and SDK guides are locally recorded
fingerprints of the inspected vendor downloads, not separately published vendor
signatures. They detect changes to those inputs on later builds.
