# Baseline MIND 2 Simulator

The repo now includes a baseline MIND 2 behavior simulator for higher-level
research work.

It does **not** execute Sony retail binaries. Instead, it gives us a controlled
host-side harness that:

- reads preserved persistent-state files from a local MIND 2 stick tree
- derives a symbolic behavior profile from those files
- replays scenario events such as `boot`, `head_touch`, and
  `shutdown_request`
- emits a trace we can compare before deciding to run a real robot trial

## Why This Exists

Behavior is a higher-level phenomenon than boot layout.

That means the repo needs more than:

- stick restoration
- file diffs
- live robot observation only

This simulator is the first baseline layer aimed at the actual research
question:

- how much of distinctive MIND 2 behavior can be approached from persistent
  state before hardware confirmation?

## Current Inputs

The simulator currently consumes these files when they are present:

- `OPEN-R/APP/DATA/P/STTLOG`
- `OPEN-R/MW/DATA/P/PAT.LOG`
- `OPEN-R/MW/CONF/CONNECT.CFG`
- `OPEN-R/SYSTEM/DATA/P/AIBO-ID`
- `OPEN-R/APP/DATA/P/AWAKING.CFG`
- `OPEN-R/APP/DATA/P/IEG.CFG`
- `OPEN-R/APP/DATA/P/FVAR`
- `OPEN-R/APP/DATA/P/GVAR`
- `OPEN-R/APP/DATA/P/SIDRDATA.BIN`

For retail MW `CONNECT.CFG`, the simulator now also recognizes the current
research structure clue:

- `8`-byte prelude
- `38` aligned `24`-byte records
- a `21`-record versioned front section
- a `17`-record stable trailing section

## Current Outputs

The simulator emits:

- a symbolic behavior profile
- a retail MW connection-table partition summary when present
- event-by-event transitions
- a shutdown-resistance judgment
- likely file-write hints for each event

That is enough to support:

- specimen vs reference comparison
- hypothesis logging
- better-targeted live trials

## Run It

Default specimen-oriented run:

```bash
make -C aperios run-mind2-behavior-sim
```

Explicit tree and scenario:

```bash
make -C aperios run-mind2-behavior-sim \
  MIND2_TREE=../features/mind2-behavior-research/build/neutral-stick \
  MIND2_SCENARIO=../simulator/scenarios/mind2-default.scn
```

## Research Position

This should be treated as:

- a baseline behavior simulator
- a hypothesis engine
- a bridge between filesystem forensics and live robot proof

This should **not** be treated as:

- a full Aperios emulator
- proof of exact Sony internal behavior logic
- a replacement for hardware confirmation

## Current CONNECT.CFG Use

The simulator currently uses the retail MW `CONNECT.CFG` clue in a deliberately
small way:

- it reports the detected `versioned:21, stable:17` partition in the profile
- it reports a known retail variant label when recognized
  - `retail-mind2-known`
  - `retail-mind3-known`
- it treats that mixed retail layout as a modest extra plausibility signal for
  socially resistant shutdown behavior

This is a hypothesis convenience, not a claim that Sony's real runtime uses the
table exactly this way.

## First Useful Result

With the current `mind2-shutdown-probe.scn` scenario, the simulator already
produces a meaningful split:

- the specimen-style tree under
  `features/mind2-behavior-research/build/sensitive-stick` defers shutdown once
- the bundled reference tree under `opt/AIBO7M2` accepts shutdown immediately

That does not prove the real internal Sony logic, but it does show that the
baseline simulator can now express one of the central observed behavior
differences as a repeatable host-side hypothesis.

It also means the simulator now exposes one of the repo's strongest structural
reverse-engineering clues directly in its runtime output, instead of keeping it
only in offline notes and scripts.

## Current Swap Boundary

A direct host-side experiment was also run in which a specimen-style tree kept
all persistent state the same but swapped only `OPEN-R/MW/CONF/CONNECT.CFG`
from retail MIND 2 to retail MIND 3.

Result:

- the simulator profile changed variant label from `retail-mind2-known` to
  `retail-mind3-known`
- but the shutdown-probe scenario outcome did not change under the current
  heuristic

This is an important boundary:

- the simulator can now *see* the variant distinction
- but it does not yet assign a stronger behavioral meaning to that distinction
