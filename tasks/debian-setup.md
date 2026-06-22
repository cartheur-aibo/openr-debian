# Debian setup

## Host assumptions

This repo assumes a Debian host with a Sony OPEN-R SDK installation under:

```bash
/usr/OPENR_SDK
```

If your SDK lives elsewhere, export `OPENRSDK_ROOT` before building:

```bash
export OPENRSDK_ROOT=/opt/OPENR_SDK
```

## Base packages

Install common build utilities:

```bash
sudo apt update
sudo apt install -y build-essential make gcc g++ flex bison patch perl unzip tar file
```

Older OPEN-R toolchains may expect older GCC/binutils/newlib sources and build scripts. Keep that toolchain isolated from your system compiler.

## Environment

```bash
source scripts/env.sh
./scripts/check-openr.sh
```

Expected variables:

```bash
OPENRSDK_ROOT=/usr/OPENR_SDK
PATH=$OPENRSDK_ROOT/bin:$PATH
```

## Debian caution

Modern Debian releases may be too new for unpatched historical build scripts. If the original toolchain does not build cleanly, use a Debian container, chroot, or VM dedicated to the SDK.

Recommended approach:

- Keep proprietary SDK files outside git.
- Keep generated binaries outside source control unless they are your own object files.
- Document exact Debian version, patches, and SDK version in `docs/build-log.md` once confirmed.
