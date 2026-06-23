# SDK Install Notes

This directory now contains the host-side OPEN-R SDK archives and the community build script needed to assemble the AIBO cross-toolchain on Linux.

This guide is based on:

- DogsBody's `Install OPEN-R on Linux` page:
  https://www.dogsbodynet.com/openr/install_openr_linux.html
- the actual files present in this `sdk/` directory
- inspection of the local `build-aibo-toolchain-3.3.6-r1.sh` script

## What Is In `sdk/`

Host-side SDK/toolchain inputs:

- `OPEN_R_SDK-1.1.5-r5.tar.gz`
- `OPEN_R_SDK-docE-1.1.5-r1.tar.gz`
- `OPEN_R_SDK-sample-1.1.5-r2.tar.gz`
- `gcc-3.3.6.tar.bz2`
- `binutils-2.15.tar.bz2`
- `newlib-1.15.0.tar.gz`
- `build-aibo-toolchain-3.3.6-r1.sh`

What these are for:

- `OPEN_R_SDK-1.1.5-r5.tar.gz`
  Sony SDK files such as `OPEN_R/bin/mkbin`, `OPEN_R/bin/stubgen2`, headers, libraries, and Memory Stick base trees
- `OPEN_R_SDK-docE-1.1.5-r1.tar.gz`
  English PDFs like `ProgrammersGuide_E.pdf` and `ModelInformation_7_E.pdf`
- `OPEN_R_SDK-sample-1.1.5-r2.tar.gz`
  Sony sample projects
- `gcc`, `binutils`, `newlib`
  the older sources used by the build script to assemble the AIBO cross-toolchain

## Important Distinction

The folders under `opt/AIBO7M2` and `opt/AIBO7M3` are ERS-7 runtime Memory Stick dumps, not the Linux host SDK.

They are still useful:

- to study the deployed `OPEN-R` filesystem layout
- to compare MIND 2 versus MIND 3 runtime contents
- to validate where built objects ultimately need to land on a programmable stick

But they do not provide the host compiler toolchain.

## What DogsBody Recommends

The DogsBody page lays out a classic Linux install flow:

1. download the toolchain script and source archives
2. extract docs and samples
3. install host prerequisites
4. run the toolchain build script
5. build a Sony sample
6. copy the sample onto a programmable Memory Stick

That page was written for much older Linux distributions, so some package names and compiler assumptions are dated.

## What We Have Confirmed Locally

The local script `build-aibo-toolchain-3.3.6-r1.sh` is configured to install into:

```bash
/usr/local/OPEN_R_SDK
```

That is also the path expected by many original Sony sample makefiles.

The `OPEN_R_SDK-1.1.5-r5.tar.gz` archive contains:

- `OPEN_R_SDK/OPEN_R/bin/mkbin`
- `OPEN_R_SDK/OPEN_R/bin/stubgen2`
- `OPEN_R_SDK/OPEN_R/include/...`

So the right directory plan for now is:

- keep the archives in `sdk/`
- use `/usr/local/OPEN_R_SDK` as the main install target unless inspection later gives us a strong reason to change it

## Recommended Install Flow On This Debian Machine

### 1. Install Debian-side prerequisites

Already present on this machine:

- `build-essential`
- `make`
- `gcc`
- `g++`
- `bison`
- `patch`
- `perl`
- `unzip`
- `tar`
- `file`
- `git`

Still missing from the original checklist:

```bash
sudo apt update
sudo apt install -y flex texinfo
```

`texinfo` is mentioned by DogsBody. `flex` is also required by the historical toolchain flow and is currently missing on this machine.

### 2. Extract docs and samples

The DogsBody page says to unpack docs and samples separately from the toolchain build.

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

### 3. Review the build script before running it

The current script:

- expects the source archives to be in the current working directory
- patches `gcc-3.3.6` and `newlib-1.15.0`
- builds a `mipsel-linux` cross-toolchain
- installs under `/usr/local/OPEN_R_SDK`

Check the install prefix in:

- `sdk/build-aibo-toolchain-3.3.6-r1.sh`

If we keep the classic path, no change is needed.

### 4. Build the toolchain

The historical DogsBody recipe used:

```bash
export CC=gcc-3.4
sudo ./build-aibo-toolchain-3.3.6-r1.sh
```

For this Debian 13 machine, do not assume `gcc-3.4` exists.

Instead:

- start by trying the script with the system compiler only after we install the missing Debian packages
- if it fails, inspect the exact error before forcing an older compiler strategy

Practical first attempt:

```bash
cd sdk
chmod +x build-aibo-toolchain-3.3.6-r1.sh
sudo ./build-aibo-toolchain-3.3.6-r1.sh
```

Expected destination:

```bash
/usr/local/OPEN_R_SDK
```

### 5. Verify installed tools

After a successful build, these should exist:

```bash
/usr/local/OPEN_R_SDK/bin/mipsel-linux-g++
/usr/local/OPEN_R_SDK/bin/mipsel-linux-strip
/usr/local/OPEN_R_SDK/OPEN_R/bin/mkbin
/usr/local/OPEN_R_SDK/OPEN_R/bin/stubgen2
```

Then run:

```bash
source scripts/env.sh
./scripts/check-openr.sh
```

### 6. Build a sample

DogsBody suggests building a Sony sample as the first proof that the toolchain works.

For ERS-7, the page specifically points to:

```bash
~/aibo/sample/ers7/BallTrackingHead7
```

In this repo, the imported equivalent is:

```bash
samples/ers7/BallTrackingHead7
```

But before using the repo copy, it is still a good idea to compare against the freshly extracted Sony sample tree from `sdk/work`.

## Notes About Age And Compatibility

The DogsBody page references older Ubuntu releases and an older host compiler setup. That is historically useful, but this machine is:

```text
Debian GNU/Linux 13 (trixie)
```

So the likely sequence is:

1. install `flex` and `texinfo`
2. run the script once
3. capture the first real build failure, if any
4. adapt from that concrete error instead of guessing

## Next Commands To Run

```bash
sudo apt update
sudo apt install -y flex texinfo
cd sdk
chmod +x build-aibo-toolchain-3.3.6-r1.sh
sudo ./build-aibo-toolchain-3.3.6-r1.sh
```

If that succeeds:

```bash
source scripts/env.sh
./scripts/check-openr.sh
cd samples/common/HelloWorld/HelloWorld
make
```
