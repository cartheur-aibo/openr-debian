# SDK Install Notes

This directory contains the host-side OPEN-R SDK archives and the community build script used to assemble the AIBO cross-toolchain on Linux.

This guide is based on:

- DogsBody's `Install OPEN-R on Linux` page:
  https://www.dogsbodynet.com/openr/install_openr_linux.html
- the actual files present in this `sdk/` directory
- local build attempts on Debian 13

The DogsBody page identifies its contents as freeware and/or copyrighted material and says they may not be sold. This file is a practical Debian-oriented guide for our repo, not a mirror of that page.

## What Is In `sdk/`

Host-side SDK and toolchain inputs:

- `OPEN_R_SDK-1.1.5-r5.tar.gz`
- `OPEN_R_SDK-docE-1.1.5-r1.tar.gz`
- `OPEN_R_SDK-sample-1.1.5-r2.tar.gz`
- `gcc-3.3.6.tar.bz2`
- `binutils-2.15.tar.bz2`
- `newlib-1.15.0.tar.gz`
- `build-aibo-toolchain-3.3.6-r1.sh`

This matches the file set listed near the top of the DogsBody page.

What they are for:

- `OPEN_R_SDK-1.1.5-r5.tar.gz`
  Sony SDK files such as `OPEN_R/bin/mkbin`, `OPEN_R/bin/stubgen2`, headers, libraries, and Memory Stick base trees
- `OPEN_R_SDK-docE-1.1.5-r1.tar.gz`
  English documentation PDFs
- `OPEN_R_SDK-sample-1.1.5-r2.tar.gz`
  Sony sample projects
- `gcc`, `binutils`, `newlib`
  older source releases used to build the AIBO cross-toolchain

## Important Distinction

The folders under `opt/AIBO7M2` and `opt/AIBO7M3` are ERS-7 runtime Memory Stick dumps, not the Linux host SDK.

They are still useful:

- to study the deployed `OPEN-R` filesystem layout
- to compare MIND 2 versus MIND 3 runtime contents
- to validate where built objects ultimately need to land on a programmable stick

But they do not provide the host compiler toolchain.

## What DogsBody Recommends

The DogsBody page lays out a classic install flow:

1. download the toolchain script and source archives
2. extract docs and samples
3. install host prerequisites
4. run the toolchain build script
5. build a Sony sample
6. copy the sample onto a programmable Memory Stick

Two important details from the top of the original page:

- it says to get the files from the Tekkotsu site
- it explicitly says not to unzip the toolchain source archives ahead of time because the build script handles that

## What We Have Confirmed Locally

The local script `build-aibo-toolchain-3.3.6-r1.sh` now installs into:

```bash
sdk/local/OPEN_R_SDK
```

That is different from the old `/usr/local/OPEN_R_SDK` convention, but it is a better fit for this Debian machine because:

- it avoids requiring root just to build the cross-toolchain
- it keeps generated SDK output inside the repo workspace
- it lets us iterate without touching system directories

The `OPEN_R_SDK-1.1.5-r5.tar.gz` archive contains:

- `OPEN_R_SDK/OPEN_R/bin/mkbin`
- `OPEN_R_SDK/OPEN_R/bin/stubgen2`
- `OPEN_R_SDK/OPEN_R/include/...`

So the current directory plan is:

- keep the original archives in `sdk/`
- unpack docs and Sony samples into `sdk/work/`
- build the toolchain and expanded SDK into `sdk/local/OPEN_R_SDK`

Nothing in the OPEN-R build requires the SDK to live under `/usr/local` as long as our environment points at the prefix we chose.

## Recommended Install Flow On This Debian Machine

### 1. Install Debian-side prerequisites

The historical DogsBody checklist still applies in spirit, but package versions are much newer here.

Useful prerequisites include:

- `build-essential`
- `make`
- `gcc`
- `g++`
- `bison`
- `flex`
- `patch`
- `perl`
- `texinfo`
- `unzip`
- `tar`
- `file`
- `git`

If needed:

```bash
sudo apt update
sudo apt install -y build-essential bison flex patch perl texinfo unzip tar file git
```

### 2. Extract docs and samples

The DogsBody page says to unpack docs and samples separately from the toolchain build, and not to pre-unpack the toolchain source archives.

From the repo root:

```bash
mkdir -p sdk/work
cd sdk/work
tar -zxf ../OPEN_R_SDK-docE-1.1.5-r1.tar.gz
tar -zxf ../OPEN_R_SDK-sample-1.1.5-r2.tar.gz
```

This gives you:

- documentation PDFs
- the original Sony sample tree

Leave these archives untouched before running the build script:

- `OPEN_R_SDK-1.1.5-r5.tar.gz`
- `gcc-3.3.6.tar.bz2`
- `binutils-2.15.tar.bz2`
- `newlib-1.15.0.tar.gz`

### 3. Review the build script before running it

The current script:

- expects the source archives to be in the current working directory
- patches `gcc-3.3.6` and `newlib-1.15.0`
- builds a `mipsel-linux` cross-toolchain
- installs under `sdk/local/OPEN_R_SDK`
- removes the obsolete `-no-cpp-precomp` flag from `CFLAGS`
- forces `MAKEINFO=true` during builds so old GNU docs do not break on newer `texinfo`

### 4. Build the toolchain

The historical DogsBody recipe used:

```bash
export CC=gcc-3.4
sudo ./build-aibo-toolchain-3.3.6-r1.sh
```

That old assumption does not fit Debian 13.

Local testing on this machine showed two concrete issues with the original flow:

- the historical `/usr/local/OPEN_R_SDK` prefix required root
- old `binutils-2.15` configure tests fail under modern GCC defaults unless we force `gnu89` mode

The working Debian-oriented invocation is:

```bash
cd sdk
chmod +x build-aibo-toolchain-3.3.6-r1.sh
CC='gcc -std=gnu89' ./build-aibo-toolchain-3.3.6-r1.sh
```

Expected destination:

```bash
sdk/local/OPEN_R_SDK
```

The `CC='gcc -std=gnu89'` override matters because some old configure checks still use K&R-style test programs that modern GCC otherwise rejects.

### 5. Verify installed tools

After a successful build, these should exist:

```bash
sdk/local/OPEN_R_SDK/bin/mipsel-linux-g++
sdk/local/OPEN_R_SDK/bin/mipsel-linux-strip
sdk/local/OPEN_R_SDK/OPEN_R/bin/mkbin
sdk/local/OPEN_R_SDK/OPEN_R/bin/stubgen2
```

Then export the local prefix before using repo helpers:

```bash
export OPENRSDK_ROOT="$PWD/sdk/local/OPEN_R_SDK"
source scripts/env.sh
./scripts/check-openr.sh
```

On this Debian machine, that check completed successfully against the repo-local SDK.

### 6. Build a sample

DogsBody suggests building a Sony sample as the first proof that the toolchain works.

For ERS-7, the original page points to `BallTrackingHead7`. In this repo, the imported equivalent is:

```bash
samples/ers7/BallTrackingHead7
```

Before using the repo copy, it is still useful to compare against the freshly extracted Sony sample tree in `sdk/work/`.

The repo-local `HelloWorld` sample has now been built successfully with:

```bash
cd samples/common/HelloWorld/HelloWorld
make OPENRSDK_ROOT="$PWD/../../../sdk/local/OPEN_R_SDK"
```

From the repo root, the less error-prone equivalent is:

```bash
make -C samples/common/HelloWorld/HelloWorld \
  OPENRSDK_ROOT="$PWD/sdk/local/OPEN_R_SDK"
```

That produced:

- `samples/common/HelloWorld/HelloWorld/helloWorld.bin`
- `samples/common/HelloWorld/HelloWorld/helloWorld.nosnap.elf`
- `samples/common/HelloWorld/HelloWorld/helloWorld.rel.elf`

To stage the sample into its Memory Stick layout:

```bash
mkdir -p samples/common/HelloWorld/MS/OPEN-R/MW/OBJS
make -C samples/common/HelloWorld/HelloWorld \
  OPENRSDK_ROOT="$PWD/sdk/local/OPEN_R_SDK" \
  install
```

That produced the deployable payload:

- `samples/common/HelloWorld/MS/OPEN-R/MW/OBJS/HELLO.BIN`

The extra `mkdir -p` is needed because this sample tree already includes `MS/OPEN-R/MW/CONF`, but not the sibling `OBJS` directory expected by the original Sony `install` target.

## Notes About Age And Compatibility

This machine is:

```text
Debian GNU/Linux 13 (trixie)
```

So the practical sequence here is:

1. keep the original archives intact
2. run the build with `CC='gcc -std=gnu89'`
3. verify the local toolchain under `sdk/local/OPEN_R_SDK`
4. build one sample
5. stage a programmable Memory Stick layout after that

## Next Commands To Run

```bash
cd sdk
chmod +x build-aibo-toolchain-3.3.6-r1.sh
CC='gcc -std=gnu89' ./build-aibo-toolchain-3.3.6-r1.sh
```

If that succeeds:

```bash
export OPENRSDK_ROOT="$PWD/sdk/local/OPEN_R_SDK"
source scripts/env.sh
./scripts/check-openr.sh
make -C samples/common/HelloWorld/HelloWorld \
  OPENRSDK_ROOT="$PWD/sdk/local/OPEN_R_SDK"
mkdir -p samples/common/HelloWorld/MS/OPEN-R/MW/OBJS
make -C samples/common/HelloWorld/HelloWorld \
  OPENRSDK_ROOT="$PWD/sdk/local/OPEN_R_SDK" \
  install
```
