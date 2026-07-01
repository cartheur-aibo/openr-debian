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

A follow-on paired swap was also tested:

- `OPEN-R/MW/CONF/CONNECT.CFG`
- `OPEN-R/MW/CONF/DESIGNDB.CFG`

both replaced together with the retail MIND 3 versions in an otherwise
specimen-style tree.

That paired swap also left the shutdown-probe outcome unchanged under the
current heuristic.

So the present simulator evidence suggests:

- MW retail config structure is worth surfacing and preserving
- but the dominant host-side behavior signals still come from persistent
  behavior/state files rather than from these MW config swaps alone

The same conclusion held on the baseline-state side as well:

- bundled `opt/AIBO7M2`
- and a baseline clone with paired MIND 3 `CONNECT.CFG + DESIGNDB.CFG` swaps

produced the same host-side profile and shutdown-probe outcome.

So the current simulator matrix points to:

- persistent app/state files as the dominant current behavior drivers
- MW retail config structure as an important contextual clue, but not yet a
  decisive standalone lever in the heuristic

## Current Dominant Lever

The next simulator-side matrix step isolated two specimen-style reversions:

1. revert only `OPEN-R/APP/DATA/P/STTLOG` to the baseline version
2. revert `OPEN-R/MW/DATA/P/PAT.LOG` plus
   `OPEN-R/APP/DATA/P/FVAR` and `OPEN-R/APP/DATA/P/GVAR` together to baseline

Observed result:

- `STTLOG`-only reversion changed the specimen-style profile back to the
  baseline-side pattern
  - `shutdown_resistance: 4 -> 2`
  - `social_attachment: 9 -> 7`
  - first shutdown request changed from deferred to accepted
- `PAT.LOG + FVAR + GVAR` reversion did **not** change the specimen-style
  profile under the current heuristic

That makes `STTLOG` the strongest current host-side behavior lever in this
simulator, ahead of both:

- the tested MW retail config swaps
- the tested `PAT.LOG + FVAR + GVAR` cluster reversion

## STTLOG Row Split

The next pass split the effective `STTLOG` change set into:

- shutdown-focused rows: `0300`, `0400`, `1000`, `1200`
- social-only row: `0046`

Observed result:

- reverting shutdown-focused rows changed:
  - `shutdown_resistance: 4 -> 2`
  - `social_attachment: 9 -> 8`
  - but the first shutdown request still deferred once under the current
    heuristic
- reverting only row `0046` changed:
  - `social_attachment: 9 -> 8`
  - while leaving `shutdown_resistance=4`
  - and leaving the shutdown verdict sequence unchanged

This suggests the current simulator is reading:

- `0300`, `0400`, `1000`, `1200` as the dominant current shutdown-state subset
- `0046` as a smaller social-weight modifier

The overlap is also informative:

- row `1200` currently contributes to both shutdown resistance and social
  attachment in the heuristic

## Row 1200 Isolation

The next split isolated row `1200` against the remaining shutdown-focused rows:

1. revert only `1200`
2. revert only `0300`, `0400`, and `1000`

Observed result:

- `1200`-only reversion changed:
  - `social_attachment: 9 -> 8`
  - while keeping `shutdown_resistance=4`
  - and keeping the shutdown verdict sequence unchanged
- `0300 + 0400 + 1000` reversion changed:
  - `shutdown_resistance: 4 -> 2`
  - while keeping `social_attachment=9`
  - and still keeping the shutdown verdict sequence unchanged under the current
    scenario/thresholds

This is the clearest current row-level split:

- `0300`, `0400`, and `1000` are the primary current shutdown-resistance rows
- `1200` behaves more like a bridge/social row than a primary shutdown driver
- `0046` remains a smaller social-only modifier

The remaining caution is that the current shutdown-probe scenario still does not
fully separate these row groups at the final verdict level, even though the
profile signals now split cleanly.

## Fatigue-First Shutdown Probe

To expose the row split at the verdict level, a sharper scenario was added:

- [simulator/scenarios/mind2-shutdown-fatigue-probe.scn](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/simulator/scenarios/mind2-shutdown-fatigue-probe.scn)

Sequence:

```text
boot
observe_startup_audio
idle_tick
shutdown_request
```

This one extra `idle_tick` lowers the available resistance margin before the
first shutdown request.

Observed result:

- specimen-style tree:
  - `shutdown_resistance=4`
  - `social_attachment=9`
  - verdict: defer once
- full `STTLOG` baseline reversion:
  - `shutdown_resistance=2`
  - `social_attachment=7`
  - verdict: accept shutdown
- `1200`-only baseline reversion:
  - `shutdown_resistance=4`
  - `social_attachment=8`
  - verdict: defer once
- `0300 + 0400 + 1000` baseline reversion:
  - `shutdown_resistance=2`
  - `social_attachment=9`
  - verdict: accept shutdown

This is the clearest current host-side conclusion:

- `0300`, `0400`, and `1000` are sufficient to flip the fatigue-first shutdown
  verdict
- `1200` changes the profile but is not sufficient, by itself, to flip that
  verdict
- the fatigue-first probe is currently a better discriminator than the older
  shutdown probe for row-level `STTLOG` work

## Single-Row Verdict Boundary

The next pass isolated the remaining shutdown-focused rows one by one under the
same fatigue-first probe:

- revert only `0300`
- revert only `0400`
- revert only `1000`
- revert `0300 + 1000` together while leaving specimen-style `0400` intact

Observed result:

- `0300`-only reversion:
  - `shutdown_resistance=4`
  - shutdown verdict still deferred once
- `0400`-only reversion:
  - `shutdown_resistance: 4 -> 2`
  - shutdown verdict changed to accepted
- `1000`-only reversion:
  - `shutdown_resistance=4`
  - shutdown verdict still deferred once
- `0300 + 1000` reversion without `0400`:
  - `shutdown_resistance=4`
  - shutdown verdict still deferred once

This is the strongest current simulator-side boundary yet:

- `0400` is sufficient, by itself, to flip the fatigue-first shutdown verdict
- `0300` and `1000` are not sufficient individually
- `0300 + 1000` together are still not sufficient without `0400`

So under the current heuristic and current sharper scenario, row `0400` is the
primary shutdown pivot inside the present `STTLOG` subset.

One more control check matters here:

- under the older `mind2-shutdown-probe.scn`, `0400`-only reversion lowers
  `shutdown_resistance` from `4` to `2`
- but it does **not** change the first shutdown verdict there, which still
  defers once because that older scenario leaves more engagement margin in
  place before the request

So the present conclusion boundary is precise:

- `0400` is the primary currently modeled shutdown pivot
- the fatigue-first probe is the scenario that exposes that pivot at the final
  verdict level
- the older shutdown probe remains useful, but it is too forgiving to separate
  this row by verdict on its own

## Forward-Transfer Check

The next causality check moved specimen-side rows into a baseline-style tree
instead of only reverting specimen rows back toward baseline.

Tested under the same fatigue-first probe:

1. baseline control tree
2. baseline tree with specimen `0400` only
3. baseline tree with specimen `0300` only
4. baseline tree with specimen `0300 + 0400 + 1000`

Observed result:

- baseline control:
  - `shutdown_resistance=2`
  - verdict: accept shutdown
- baseline + specimen `0400` only:
  - `shutdown_resistance: 2 -> 4`
  - verdict: defer once
- baseline + specimen `0300` only:
  - `shutdown_resistance=2`
  - verdict: accept shutdown
- baseline + specimen `0300 + 0400 + 1000`:
  - `shutdown_resistance=4`
  - verdict: defer once

This strengthens the current host-side claim substantially:

- specimen-style `0400` is not only necessary in the strongest current
  backward-reversion test
- it is also sufficient, by itself, to push the baseline-style tree across the
  fatigue-first shutdown verdict boundary in the forward direction

So under the present heuristic, `0400` behaves like an active shutdown-state
lever rather than only a passive correlated marker.

## Lean-Baseline Context Boundary

The next stress test used the packaged MIND 2 stick tree under
`features/aibo-mind2/build/stick`, which starts from a leaner baseline profile
than `baseline-control`:

- baseline packaged tree:
  - `shutdown_resistance=1`
  - `social_attachment=5`
  - verdict: accept shutdown

That tree was then given specimen-side rows in small combinations.

Observed result:

- packaged baseline + specimen `0400` only:
  - `shutdown_resistance: 1 -> 3`
  - `social_attachment=5`
  - verdict: still accept shutdown
- packaged baseline + specimen `0300` only:
  - `shutdown_resistance: 1 -> 2`
  - verdict: still accept shutdown
- packaged baseline + specimen `0300 + 0400 + 1000`:
  - `shutdown_resistance=4`
  - `social_attachment=5`
  - verdict: still accept shutdown
- packaged baseline + specimen `0400 + 1200`:
  - `shutdown_resistance=3`
  - `social_attachment=8`
  - verdict: defer once
- packaged baseline + specimen `0400 + 0046 + 1200`:
  - `shutdown_resistance=3`
  - `social_attachment=9`
  - verdict: defer once

This refines the current interpretation:

- `0400` remains the primary shutdown-side pivot
- but the final verdict also depends on enough engagement/social weight being
  present at shutdown time
- on leaner baselines, specimen-style `1200` is sufficient to supply that
  missing bridge
- `0046` can add social weight too, but it is not required once `1200` is in
  place

So the current host-side model is best described as:

- `0400`: primary shutdown-resistance lever
- `1200`: primary bridge/social amplifier that can make `0400` matter at the
  verdict boundary on leaner baselines
- `0046`: smaller social modifier

One more control sharpens that boundary:

- packaged baseline + specimen `1200` only:
  - `shutdown_resistance=1`
  - `social_attachment=8`
  - verdict: accept shutdown
- packaged baseline + specimen `0400 + 0046`:
  - `shutdown_resistance=3`
  - `social_attachment=6`
  - verdict: accept shutdown
- packaged baseline + specimen `0400 + 1200`:
  - `shutdown_resistance=3`
  - `social_attachment=8`
  - verdict: defer once

So `1200` has no independent current shutdown-deferral power by itself, but it
is the strongest current companion row for making `0400` cross the fatigue-first
verdict boundary on lean baselines.

The remaining currently modeled social-side substitutes were then checked on
that same packaged baseline:

- specimen `0400 + 0055`:
  - `shutdown_resistance=3`
  - `social_attachment=5`
  - verdict: accept shutdown
- specimen `0400 + 0046 + 0055`:
  - `shutdown_resistance=3`
  - `social_attachment=6`
  - verdict: accept shutdown
- specimen `0046 + 0055 + 1200` without `0400`:
  - `shutdown_resistance=1`
  - `social_attachment=9`
  - verdict: accept shutdown

So the current minimal effective pair on the lean packaged MIND 2 baseline is
now much better constrained:

- `0400 + 1200` is sufficient
- the currently modeled alternatives built from `0046` and `0055` do not
  substitute for that pair
