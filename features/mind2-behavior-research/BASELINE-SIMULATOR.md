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

## Non-STTLOG Boundary

The next boundary check asked whether the remaining specimen-side persistent
state outside the currently modeled `STTLOG` rows could replace `1200`'s bridge
role on the lean packaged MIND 2 baseline.

Three variants were tested, each keeping specimen `0400` but replacing
different non-`STTLOG` state from the specimen:

- `0400 + FVAR + GVAR`
- `0400 + IEG.CFG + SIDRDATA.BIN`
- `0400 + all remaining differing non-STTLOG state`

Observed result:

- all three variants kept:
  - `shutdown_resistance=3`
  - `social_attachment=5`
  - verdict: accept shutdown

So the current simulator-side boundary is:

- none of the remaining currently tested non-`STTLOG` specimen state can
  substitute for `1200`'s bridge role under the present heuristic
- the current bridge still lives inside the presently modeled `STTLOG` row set

This should be interpreted carefully:

- it is a boundary of the current simulator model, not proof that those files
  have no real behavioral meaning on hardware
- in the current code, `FVAR` and `GVAR` only influence adaptability, while
  `IEG.CFG` and `SIDRDATA.BIN` are surfaced but do not yet alter shutdown or
  social scoring

That last part is now partially outdated in an important way.

The simulator was then extended with a first explicit `IEG.CFG` semantic hook:

- detect a sparse repeated-tail pattern in specimen-side `IEG.CFG`
- treat it as a current fixed-routine / rigid-engagement clue
- `social_attachment += 2`
- `adaptability -= 1`
- `shutdown_resistance += 1` only when `0400` is already active

Under that revised model on the lean packaged MIND 2 baseline:

- specimen `IEG.CFG` alone:
  - `shutdown_resistance=1`
  - `social_attachment=8`
  - verdict: accept shutdown
- specimen `0400 + IEG.CFG`:
  - `shutdown_resistance=4`
  - `social_attachment=7`
  - verdict: defer once
- specimen `0400 + SIDRDATA.BIN`:
  - `shutdown_resistance=3`
  - `social_attachment=5`
  - verdict: accept shutdown

So the current simulator-side bridge is no longer confined only to `STTLOG`
row `1200`:

- specimen `1200` still works as a bridge companion for `0400`
- but the newly modeled specimen-side `IEG.CFG` sparse-pattern clue also works
- `SIDRDATA.BIN` still does not under the current heuristic

This is a stronger research position than before:

- the shutdown pivot still lives primarily in `STTLOG` row `0400`
- but at least one non-`STTLOG` persistent-state file now has explicit modeled
  behavioral weight strong enough to cross the same verdict boundary

The first draft of that heuristic was then tightened so `IEG.CFG` would not
become a standalone shutdown trigger on the stronger baseline side.

Current calibrated check:

- `baseline-control + specimen IEG.CFG`:
  - `shutdown_resistance=2`
  - `social_attachment=9`
  - verdict: accept shutdown

So the present calibrated `IEG.CFG` role is:

- not a standalone shutdown pivot
- but a companion bridge signal that can help `0400` cross the verdict boundary
  on lean baselines

## Alternate Scenario Comparison

The next check compared the two current bridge paths:

- specimen `0400 + 1200`
- specimen `0400 + IEG.CFG`

against the lean packaged MIND 2 baseline under two additional scenarios:

1. `mind2-shutdown-probe.scn`
2. `mind2-default.scn`

### Older Shutdown Probe

Under `mind2-shutdown-probe.scn`, both bridge paths now defer the first
shutdown request:

- `0400 + 1200`
  - `shutdown_resistance=3`
  - `social_attachment=8`
  - first shutdown request deferred once
- `0400 + IEG.CFG`
  - `shutdown_resistance=4`
  - `social_attachment=7`
  - first shutdown request deferred once

So the outcome matches, but the profile shape differs:

- `1200` expresses more as social/engagement weight
- `IEG.CFG` expresses more as shutdown-side rigidity

### Default Sleep-Oriented Pass

Under `mind2-default.scn`, the same split persists:

- lean packaged baseline:
  - enters sleep
- `0400 + 1200`
  - `shutdown_resistance=3`
  - `social_attachment=8`
  - postpones sleep
- `0400 + IEG.CFG`
  - `shutdown_resistance=4`
  - `social_attachment=7`
  - postpones sleep
- `0400` only:
  - `shutdown_resistance=3`
  - `social_attachment=5`
  - still enters sleep

This strengthens the current reading:

- `1200` and calibrated `IEG.CFG` are both viable current bridge signals
- but they are not identical
- `1200` is the more social-weighted bridge
- `IEG.CFG` is the more rigidity/resistance-weighted bridge

## Current Event-Model Equivalence

One more conclusion boundary is now clear:

- `0400 + 1200` and calibrated `0400 + IEG.CFG` often converge to the same
  verdict under the current event model, even though their profile shapes differ

Current lean-baseline profiles:

- `0400 + 1200`
  - `shutdown_resistance=3`
  - `social_attachment=8`
- `0400 + IEG.CFG`
  - `shutdown_resistance=4`
  - `social_attachment=7`

Why they often converge:

- boot engagement is derived from `social_attachment / 2`
  - `1200` path boots with engagement `4`
  - `IEG.CFG` path boots with engagement `3`
- but the `IEG.CFG` path carries `+1` more shutdown resistance
- after a single `head_touch`, both land in the same practical shutdown band
  under the current formula
- after a single `head_touch`, both also satisfy the present sleep-postponement
  gate

So under the current event algebra:

- `1200` and calibrated `IEG.CFG` are distinguishable in profile shape
- but not always distinguishable at the final verdict level
- separating them further likely requires richer event semantics, not merely
  more scenario shuffling with the same current event rules

That richer event step has now been taken for sleep behavior.

## Routine-Sleep Probe

A sharper sleep scenario was added:

- [simulator/scenarios/mind2-routine-sleep-probe.scn](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/simulator/scenarios/mind2-routine-sleep-probe.scn)

Sequence:

```text
boot
observe_startup_audio
idle_tick
sleep_request
```

The simulator's `sleep_request` handling now distinguishes:

- high-engagement postponement
- routine-preservation postponement for the calibrated sparse `IEG.CFG` path

Observed result on the lean packaged MIND 2 baseline:

- baseline:
  - enters sleep
- `0400` only:
  - enters sleep
- `0400 + 1200`:
  - enters sleep
- `0400 + IEG.CFG`:
  - postpones sleep to preserve a fixed routine state

This is the first current scenario that cleanly separates the two bridge paths
at the verdict level:

- `1200` remains the more social-weighted bridge
- calibrated `IEG.CFG` now has a distinct routine-preservation expression that
  `1200` does not trigger under the same no-touch sleep probe
