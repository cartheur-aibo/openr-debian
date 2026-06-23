# openr-debian for ERS-7

Debian workspace for building and testing Sony AIBO ERS-7 OPEN-R software.

## Start Here

1. Check the local boot layout:

```bash
scripts/simulate-openr-boot.sh samples/common/HelloWorld
```

2. Run the host-side lifecycle proof:

```bash
make -C aperios run-hello-world
```

3. If you want a real Memory Stick payload, build and stage `HelloWorld`:

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

## What This Repo Does

- builds legacy OPEN-R tools on Debian
- builds real OPEN-R sample payloads for Memory Stick deployment
- simulates OPEN-R boot layout from `OBJECT.CFG`
- runs a first host-side lifecycle shim for OPEN-R objects

## Easy Commands

Check what a local OPEN-R stick tree would try to boot:

```bash
scripts/simulate-openr-boot.sh samples/common/HelloWorld
```

Run the host-side lifecycle simulator for the original Sony `HelloWorld` sample:

```bash
make -C aperios run-hello-world
```

## Build A Real Sample

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

That produces:

- `samples/common/HelloWorld/MS/OPEN-R/MW/OBJS/HELLO.BIN`

## Where To Look

- [sdk/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/sdk/README.md) for Debian SDK setup
- [simulator/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/simulator/README.md) for simulator scope and plan
- [aperios/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/aperios/README.md) for OPEN-R/Aperios messaging notes

## Rule

Use a separate programmable Memory Stick, not your working AIBO MIND stick.
