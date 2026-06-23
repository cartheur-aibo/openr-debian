# Build Log

## 2026-06-23

Machine: current Debian host

### What was checked

- sourced `scripts/env.sh`
- ran `bash scripts/check-openr.sh`
- attempted first sample build in `samples/common/HelloWorld/HelloWorld`
- searched common install roots for OPEN-R SDK directories and tool binaries

### Findings

- repo default environment initially pointed at `/usr/OPENR_SDK`
- Sony sample makefile expects `/usr/local/OPEN_R_SDK`
- no SDK/toolchain installation was found under:
  - `/usr`
  - `/usr/local`
  - `/opt`
  - `/home/cartheur`
- `check-openr.sh` failed because `/usr/OPENR_SDK` does not exist
- sample build failed because `/usr/local/OPEN_R_SDK/bin/mipsel-linux-g++` does not exist
- `opt/AIBO7M2` and `opt/AIBO7M3` were later added and appear to be ERS-7 runtime Memory Stick dumps, not the host SDK/toolchain
- the actual SDK source archives were later added under `sdk/`

### Concrete failing build output

```text
/usr/local/OPEN_R_SDK/bin/mipsel-linux-g++ ... -o HelloWorld.o -c HelloWorld.cc
make: /usr/local/OPEN_R_SDK/bin/mipsel-linux-g++: No such file or directory
make: *** [Makefile:37: HelloWorld.o] Error 127
```

### Repo adjustments made

- `scripts/env.sh` now auto-detects:
  - `/usr/OPENR_SDK`
  - `/usr/local/OPEN_R_SDK`
- `scripts/check-openr.sh` now checks both the simple repo layout and the classic Sony `OPEN_R` layout
- the top-level cribsheet already points to Sony `HelloWorld` as the first true build target
- `sdk/README.md` now documents the local SDK archives and the DogsBody-based install flow

### Current blocker

This machine does not currently have the Sony OPEN-R SDK and cross-toolchain installed in a detectable location.

### Next step once SDK files are available

1. install or unpack the SDK/toolchain
2. rerun:

```bash
source scripts/env.sh
bash scripts/check-openr.sh
cd samples/common/HelloWorld/HelloWorld
make
```

3. record the real SDK path, Debian quirks, and first passing sample here
