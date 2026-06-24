# ERS-7 Runtime-System Hybrid Stick

This feature builds a new test stick that keeps the small SDK `MW/` layer but
replaces the SDK `SYSTEM/` side with the real ERS-7 runtime system from
`opt/AIBO7M2/OPEN-R`.

This is the next step after proving:

- the 8 MB stick can be formatted correctly
- the plain SDK programming stick still fails on the robot
- the real ERS-7 stick uses a different system object set than the SDK base

## Do This

Build the smallest runtime-derived boot test:

```bash
FEATURE_SLUG=ers7-runtime-base \
SYSTEM_SOURCE=runtime-mind2 \
STICK_FLAVOR=BASIC \
PAYLOAD_MODE=base-only \
./scripts/build-ers7-feature-stick.sh
```

That creates:

- `features/ers7-runtime-base/build/stick`

Current size is about `1.07 MiB`, so it still fits easily on the experimental
8 MB stick.

## What This Build Is

This hybrid stick uses:

- `APERINIT.GZ`, `APERIOS.GZ`, `BOOTPARA`, and `STIKSAFE.BIN` from
  `opt/AIBO7M2/OPEN-R`
- the full `SYSTEM/` tree from `opt/AIBO7M2/OPEN-R/SYSTEM`
- the small SDK `MW/` tree from `MS_ERS7/BASIC/memprot`
- an empty `MW/CONF/OBJECT.CFG` in `base-only` mode

That matters because it lets us test whether the robot accepts the real ERS-7
system stack better than the minimal SDK system stack, without needing a full
19 MB AIBO MIND image.

## Copy To Memory Stick

Copy these from:

- `features/ers7-runtime-base/build/stick`

to the root of the mounted Memory Stick:

- `MEMSTICK.IND`
- `OPEN-R/`

Example:

```bash
rsync -rltD --delete /home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7-runtime-base/build/stick/ /tmp/aibo-stick/
sync
```

Then unmount the stick cleanly and test it in the robot.

## What We Expect

If the failure was caused by a mismatch between the SDK system base and the
robot's actual ERS-7 runtime expectations, this hybrid stick has a better
chance of booting.

If this hybrid stick still fails with the same sound, the remaining suspect
gets narrower:

- the experimental 8 MB media itself
- another hidden boot expectation outside the system object set
- a deeper incompatibility between programming-stick boot and this robot

## Useful Knowledge

- The full `opt/AIBO7M2/OPEN-R` runtime dump is about `19.6 MB`, so it does
  not fit on an 8 MB stick as-is.
- The `SYSTEM/` subtree alone is small enough to reuse in a hybrid stick.
- The real ERS-7 system object set includes `RRWH.BIN`, `IPSTACK.BIN`,
  `NETCONFS.BIN`, `WLANDRV.BIN`, and `WLANENBL.BIN`, which differ from the
  minimal SDK base.
