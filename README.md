# openr-debian for ERS-7

Debian workspace for developing existing and creating new (modern) Aibo ERS-7 OPEN-R software.

The main effort in this repo is OPEN-R / Aperios runtime work under `aperios/`: documenting the original execution model from Sony's manuals, building a small host-side shim on Debian, and using original sample code to prove lifecycle behavior before attempting deeper simulation.

## Current Focus

- documenting the OPEN-R / Aperios object model, lifecycle, and messaging behavior from the Sony manuals
- building a host-side shim under `aperios/` for original OPEN-R objects
- validating assumptions by compiling and running the Sony `HelloWorld` sample on Debian
- using that runtime understanding to guide later simulator and tooling work

## Start Here

1. Read the OPEN-R / Aperios notes and document map:

```bash
sed -n '1,220p' aperios/README.md
```

2. Run the host-side lifecycle proof:

```bash
make -C aperios run-hello-world
```

3. Check the local boot layout:

```bash
scripts/simulate-openr-boot.sh samples/common/HelloWorld
```

4. If you want a real Memory Stick payload, build and stage `HelloWorld`:

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

- studies and documents the OPEN-R / Aperios runtime model using Sony manuals and companion papers
- builds a first host-side OPEN-R lifecycle shim under `aperios/`
- builds legacy OPEN-R tools on Debian
- builds real OPEN-R sample payloads for Memory Stick deployment
- simulates OPEN-R boot layout from `OBJECT.CFG`
- preserves enough original sample structure to test assumptions against real Sony source

## Aperios Work

The center of gravity for the current project is [`aperios/README.md`](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/aperios/README.md). It maps the local Sony manuals and academic papers, summarizes the OPEN-R / Aperios runtime model, and documents the first Debian host shim for running original OPEN-R sample code.

Right now that work has established:

- a practical object model based on single-threaded message handling
- an explicit lifecycle model centered on `DoInit`, `DoStart`, `DoStop`, and `DoDestroy`
- a working Debian host proof for the original Sony `HelloWorld` sample
- clear next steps around subject/observer readiness, buffering, and mailbox scheduling

## Easy Commands

Read the current OPEN-R / Aperios notes:

```bash
sed -n '1,220p' aperios/README.md
```

Run the host-side lifecycle simulator for the original Sony `HelloWorld` sample:

```bash
make -C aperios run-hello-world
```

Check what a local OPEN-R stick tree would try to boot:

```bash
scripts/simulate-openr-boot.sh samples/common/HelloWorld
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

## MIND 2 vs MIND 3

In this repo, the preserved MIND 2 and MIND 3 stick trees share the same
top-level Sony layout:

- `MEMSTICK.IND`
- `OPEN-R/`
- `PALM/`

The practical differences are:

- MIND 2 is our smaller preserved baseline under
  [features/aibo-mind2/build/stick](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/aibo-mind2/build/stick),
  and it is the one we have already verified live on the real robot over Wi-Fi
  and HTTP.
- MIND 3 is preserved under
  [opt/AIBO7M3](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/opt/AIBO7M3)
  and is much larger in this repo, about `55M` versus about `20M` for the
  staged MIND 2 tree.
- The MIND 3 image carries extra stock content compared with the preserved
  MIND 2 tree, including more Palm-side files plus additional app-facing
  content such as `OPEN-R/APP/PC/DIARY`, `OPEN-R/APP/OBJS/SA.BIN`, and
  `OPEN-R/APP/OBJS/STM.BIN`.
- For repeatable testing, the repo now exposes both paths as separate staging
  workflows: [features/ers7m2-test-stick/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7m2-test-stick/README.md)
  for MIND 2 and [features/ers7m3-test-stick/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7m3-test-stick/README.md)
  for MIND 3.

## Where To Look

- [aperios/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/aperios/README.md) for the main OPEN-R / Aperios runtime notes, document map, and host-shim status
- [sdk/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/sdk/README.md) for Debian SDK setup
- [simulator/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/simulator/README.md) for simulator scope and plan
- [features/ers7-wifi/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7-wifi/README.md) for ERS-7 Wi-Fi setup from the bundled Sony docs
- [features/aibo-mind2/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/aibo-mind2/README.md) for staging the bundled AIBO MIND 2 ERS-7 stick layout
- [features/new-sticks-playbook/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/new-sticks-playbook/README.md) for the handoff workflow and proven conclusions for new 64 MB Sony sticks
- [features/new-sticks-playbook/TROUBLESHOOTING.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/new-sticks-playbook/TROUBLESHOOTING.md) for the operational checklist and failure-triage guide during delicate stick bring-up
- [features/ers7m2-test-stick/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7m2-test-stick/README.md) for the larger-stick full MIND 2 app-testing workflow
- [features/ers7m3-test-stick/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7m3-test-stick/README.md) for the larger-stick full MIND 3 app-testing workflow
- [features/ers7-camera-stream/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7-camera-stream/README.md) for the ERS-7 `W3AIBO` camera-serving workflow on port `60080`
- [features/hello-world/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/hello-world/README.md) for a scratch-built ERS-7 Wi-Fi test stick
- [features/ers7-runtime-base/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7-runtime-base/README.md) for a runtime-system hybrid ERS-7 test stick
- [features/ers7-stick-forensics/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7-stick-forensics/README.md) for raw-layout differences between recreated and known-good sticks

## Rule

Use a separate programmable Memory Stick, not your working AIBO MIND stick.
https://discord.gg/UKeCqAaK4d