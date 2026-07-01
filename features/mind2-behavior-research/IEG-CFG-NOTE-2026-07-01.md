# IEG.CFG Note: July 1, 2026

This note records the first explicit simulator-side semantic hook added for
`OPEN-R/APP/DATA/P/IEG.CFG`.

## Why This File Matters

`IEG.CFG` has long been in the candidate set:

- it differs between the specimen-side preserved tree and the packaged MIND 2
  baselines
- it is structured rather than random
- until now, the simulator only surfaced its file size and gave it no explicit
  behavioral meaning

That made it a natural next file once the current `STTLOG` row matrix reached a
conclusion boundary.

## Current Structural Clue

The current packaged MIND 2 baseline and specimen-side `IEG.CFG` files share
the same header and size:

- header: `IEPR`
- size: `1697` bytes

But their tails differ sharply:

- packaged MIND 2 baseline:
  - dense or mixed changing schedule-like tail
  - `ieg_tail_zero_words=2/408`
  - `ieg_tail_48_words=73`
- specimen-side tree:
  - much sparser tail with many zero words and repeated `0x42480000`
  - `ieg_tail_zero_words=197/408`
  - `ieg_tail_48_words=199`

The current simulator names that specimen-side pattern:

- `ieg_pattern=sparse-fixed-schedule`

This is still only a heuristic label, not a decoded Sony field name.

## Stronger Structural Characterization

The current byte-level pass makes the distinction sharper than "sparser tail."

Treating the body after offset `0x40` as `8`-byte cells:

- both files contain `204` whole cells after the header
- packaged baseline:
  - `203/204` cells have a non-zero second word
  - first-word values are mixed
    - `48.0` (`0x42480000`): `73`
    - `60.0` (`0x42700000`): `62`
    - `100.0` (`0x42c80000`): `62`
    - other: `7`
- specimen-side file:
  - `196/204` cells have a zero second word
  - first-word values are overwhelmingly flattened to `48.0`
    - `48.0` (`0x42480000`): `199`
    - `60.0` (`0x42700000`): `1`
    - other: `4`

The dominant specimen-side repeated cell is:

- first word `0x42480000` (`48.0`)
- second word `0x00000000`

Count:

- `196` cells

So the specimen file is not just "more zero-heavy." It looks like a broad
flattening of what is otherwise a denser mixed-value schedule lattice in the
packaged baseline.

## Long Zero-Second Run

The current specimen-side file also contains a long contiguous run of zeroed
second words:

- cell range: `2..99`
- byte range: `0x50..0x358`
- run length: `98` cells

That is a stronger clue than isolated local edits:

- the baseline body appears to carry many changing second-word values
- the specimen body collapses a large early-middle region into repeated
  `48.0 + 0` cells

This is one of the best current reasons to think the present simulator-side
"routine rigidity" interpretation is at least structurally grounded, even if
the Sony field meaning is still undecoded.

## Partial Restoration Threshold Probe

The next question was whether the simulator-side routine-preservation effect
fades gradually as the specimen file is restored toward the packaged baseline,
or whether the current heuristic flips at a distinct structural boundary.

To test that, staged trees were generated that keep the specimen-side
`0400 + IEG.CFG` path but progressively restore the beginning of the long
zero-second run from the packaged baseline.

Current restoration matrix:

- restored first `0` cells of the run
- restored first `16`
- restored first `32`
- restored first `48`
- restored first `52`
- restored first `56`
- restored first `60`
- restored first `61`
- restored first `62`
- restored first `63`
- restored first `64`
- restored first `80`
- restored first `98`

Observed result on both:

- `mind2-routine-sleep-probe.scn`
- `mind2-routine-disruption-probe.scn`

The current simulator-side routine path remains intact through:

- `61` restored cells

And collapses at:

- `62` restored cells

At that boundary:

- `61` restored cells
  - still classifies as `ieg_pattern=sparse-fixed-schedule`
  - still yields `routine_rigidity=3`
  - still postpones sleep
  - still preserves routine after disruption
- `62` restored cells
  - flips to `ieg_pattern=dense-or-mixed`
  - drops to `routine_rigidity=0`
  - enters sleep
  - breaks routine after disruption

## Current Meaning Of The Threshold

This looks less like a gradual semantic decay and more like a hard classifier
edge in the current heuristic.

That edge matches the present code:

- body words: `408`
- sparse-pattern condition requires:
  - zero words `>= 408 / 3`
  - `48.0` words `>= 408 / 4`

Empirically:

- `61` restored cells:
  - zero words: `136`
  - `48.0` words: `141`
  - still passes
- `62` restored cells:
  - zero words: `135`
  - `48.0` words: `140`
  - fails the zero-word threshold

So the present transition is not yet evidence that Sony's real logic uses a
hard boundary there.

It is evidence that:

- the specimen-side file shape is strong enough to survive substantial partial
  restoration
- the current host-side simulator hook is dominated by a measurable structural
  threshold rather than by a smooth gradient

## Gradient Follow-On

That hard edge was useful as a first classifier, but it is not the best long-
term behavioral model if the goal is dynamical autonomy rather than a static
yes/no label.

So the simulator was then shifted to a graded `IEG.CFG` signal:

- keep `sparse-fixed-schedule` as a descriptive structural label
- add a continuous `ieg_rigidity_gradient`
- derive:
  - `routine_rigidity_signal`
  - initial `routine_hold`
  - routine decay under idle and disruption
  from that continuous signal instead of from the boolean label alone

## Current Gradient Result

Under the graded model:

- strong specimen-side file:
  - `ieg_rigidity_gradient=0.99`
  - `routine_rigidity=6`
  - still preserves routine and stays awake under the routine-disruption probe
- packaged baseline, `0400`, and `0400 + 1200`:
  - `ieg_rigidity_gradient=0.00`
  - `routine_rigidity=0`
  - still break routine and sleep

So the major verdict-level separation remains intact.

## Transitional Band

The more interesting change is at the old threshold boundary.

Under the graded model:

- `61` restored cells:
  - `ieg_rigidity_gradient=0.50`
  - `routine_rigidity=3`
  - still reaches `verdict: routine state preserved`
  - but falls to sleep by the final state after that disruption pass
- `62` restored cells:
  - `ieg_rigidity_gradient=0.41`
  - `routine_rigidity=2`
  - `verdict: routine broken`
  - final state: sleep
- `63` restored cells:
  - `ieg_rigidity_gradient=0.33`
  - `routine_rigidity=2`
  - `verdict: routine broken`
  - final state: sleep

This is the key improvement over the first-draft classifier:

- the old model collapsed `62+` immediately to zero routine signal
- the new model preserves a reduced residual `IEG` influence even after the
  old structural label has flipped

So the current best interpretation is:

- the hard threshold is still a useful structural landmark
- but the behavioral model is now smoother internally
- and the `61/62/63` region should be treated as a transitional band, not as a
  pure on/off cliff

## Routine-Endurance Probe

To see whether the new gradient behaves dynamically rather than only at a
single decision point, a longer routine-pressure scenario was added:

- `mind2-routine-endurance-probe.scn`

Sequence:

- `boot`
- `observe_startup_audio`
- `idle_tick`
- `schedule_disruption`
- `idle_tick`
- `schedule_disruption`
- `sleep_request`

## Current Endurance Result

The endurance probe gives a stronger time-based separation:

- strong specimen-side `0400 + IEG.CFG`
  - `routine_rigidity_signal=0.99`
  - preserves routine across both disruptions
  - still postpones sleep at the end
- partial restoration, `48` restored cells
  - `routine_rigidity_signal=0.88`
  - also preserves routine across both disruptions
  - still postpones sleep at the end
- transitional band, `61` restored cells
  - `routine_rigidity_signal=0.50`
  - preserves routine on the first disruption
  - but fails on the second disruption
  - enters sleep by the end
- transitional band, `62` restored cells
  - `routine_rigidity_signal=0.41`
  - fails already on the first disruption
  - enters sleep
- weaker partial restoration, `80` restored cells
  - `routine_rigidity_signal=0.10`
  - breaks routine immediately
  - enters sleep

## Why This Matters

This is the clearest current evidence that the gradient model is doing real
behavioral work instead of just reporting a prettier internal number.

The endurance probe now distinguishes at least three routine-strength regimes:

- strong routine preservation
- transitional one-cycle preservation
- weak/no routine preservation

That is a better fit for a dynamical-autonomy research direction than the
earlier pure classifier cliff.

## Social-Endurance Comparison

The next question was whether the current `1200` path also forms a multi-cycle
persistence family, or whether it is a different kind of shorter-lived signal.

Two matching probes were added:

- `mind2-social-endurance-probe.scn`
  - uses `head_touch`
- `mind2-low-salience-endurance-probe.scn`
  - uses `back_touch`

Both then apply:

- `idle_tick`
- `schedule_disruption`
- `idle_tick`
- `schedule_disruption`
- `sleep_request`

## Current Dynamic Separation

Under `mind2-social-endurance-probe.scn`:

- `0400 + 1200`
  - shows one-cycle social persistence
  - first disruption: `verdict: seek interaction rather than preserve routine`
  - second disruption: falls to `verdict: routine broken`
  - final state: sleep
- strong specimen-side `0400 + IEG.CFG`
  - preserves routine across both disruptions
  - final state: awake
- transitional `61` restored-cell `IEG` variant
  - first disruption: `seek interaction rather than preserve routine`
  - second disruption: `routine broken`
  - final state: sleep

Under `mind2-low-salience-endurance-probe.scn`:

- `0400 + 1200`
  - no longer shows the first-cycle social persistence
  - breaks routine immediately
  - final state: sleep
- strong specimen-side `0400 + IEG.CFG`
  - still preserves routine across both disruptions
  - final state: awake
- transitional `61` restored-cell `IEG` variant
  - preserves one routine cycle
  - then fails on the second cycle
  - final state: sleep

## Current Interpretation

This is the clearest current time-based separation in the repo:

- `1200`
  - socially cued
  - short-lived
  - salience-sensitive
- specimen-side `IEG.CFG`
  - routine-preserving
  - multi-cycle
  - less dependent on touch salience
- transitional `IEG` variants
  - intermediate durability

That is a much stronger dynamic distinction than the earlier single-event
shutdown/sleep probes could provide.

## Follow-On Social Tuning

The next question was whether the `1200` path could support a stronger dynamic
social persistence family without collapsing into the routine-preserving one.

The simulator now carries a separate social-side state:

- `social_persistence_signal`
- runtime `social_hold`

This allows social persistence to decay on its own timescale instead of being
represented only by raw engagement.

## Current Tuned `1200` Result

With that social-carry state in place:

- `0400 + 1200` under `mind2-social-endurance-probe.scn`
  - first disruption: `seek interaction rather than preserve routine`
  - second disruption: `seek interaction rather than preserve routine`
  - final state: still sleeps
- `0400 + 1200` under `mind2-low-salience-endurance-probe.scn`
  - first disruption: `seek interaction rather than preserve routine`
  - second disruption: `routine broken`
  - final state: sleep

So `1200` can now perform a stronger feat than before:

- it sustains two cycles of socially cued persistence after a strong
  high-salience cue

But it still stays distinct from the routine family because:

- it does not postpone the final sleep transition in the endurance pass
- it remains salience-sensitive
- it does not preserve routine semantics

This is a better dynamic reading of `1200` than the earlier one-cycle-only
model.

## Current Simulator Use

The simulator now treats that sparse repeated-tail pattern as a narrow current
clue for:

- stronger social attachment
- lower adaptability
- an extra shutdown-side nudge only when another shutdown pivot is already
  active

Current heuristic effect:

- `social_attachment += 2`
- `adaptability -= 1`
- `shutdown_resistance += 1` only when specimen-style `0400` is already active

The intended interpretation is:

- a more rigid or fixed routine pattern
- not necessarily more adaptable
- but more likely to stay engaged or resist immediate shutdown once another
  shutdown-side lever is already active

## Lean-Baseline Result

On the lean packaged MIND 2 baseline:

- baseline:
  - `shutdown_resistance=1`
  - `social_attachment=5`
  - verdict: accept shutdown

With specimen-side `IEG.CFG` alone:

- `shutdown_resistance=1`
- `social_attachment=8`
- verdict: accept shutdown

So specimen `IEG.CFG` does **not** independently produce shutdown deferral.

## Companion Result With 0400

The more important result appears when specimen `IEG.CFG` is paired with
specimen-side `STTLOG` row `0400` on that same lean baseline:

- baseline + specimen `0400` only:
  - `shutdown_resistance=3`
  - `social_attachment=5`
  - verdict: accept shutdown
- baseline + specimen `0400 + IEG.CFG`:
  - `shutdown_resistance=4`
  - `social_attachment=7`
  - `adaptability=4`
  - verdict: defer once
- baseline + specimen `0400 + SIDRDATA.BIN`:
  - `shutdown_resistance=3`
  - `social_attachment=5`
  - verdict: accept shutdown

So the current model boundary is:

- specimen-side `IEG.CFG` can substitute for `1200`'s bridge role on the lean
  baseline once `0400` is already present
- specimen-side `SIDRDATA.BIN` does not do that under the current heuristic
- specimen-side `IEG.CFG` still does not replace `0400` itself

This calibration also matters on the stronger baseline side:

- `baseline-control + specimen IEG.CFG`:
  - `shutdown_resistance=2`
  - `social_attachment=9`
  - verdict: accept shutdown

So the current heuristic no longer lets specimen `IEG.CFG` act as a
standalone shutdown-deferral trigger on its own.

## Alternate Scenario Comparison

The calibrated `IEG.CFG` bridge path was then compared directly with the
current `1200` bridge path on the lean packaged MIND 2 baseline.

### Older Shutdown Probe

Both paths now defer the first shutdown request:

- `0400 + 1200`
  - `shutdown_resistance=3`
  - `social_attachment=8`
- `0400 + IEG.CFG`
  - `shutdown_resistance=4`
  - `social_attachment=7`

So the present distinction is not in the top-line outcome there, but in the
profile shape:

- `1200` is the more social-weighted bridge
- `IEG.CFG` is the more shutdown-rigidity-weighted bridge

### Default Sleep Pass

Under `mind2-default.scn`, the same distinction persists:

- lean packaged baseline enters sleep
- `0400` only still enters sleep
- `0400 + 1200` postpones sleep
- `0400 + IEG.CFG` also postpones sleep

Again, the top-line outcome aligns, but the profile shape stays different:

- `1200`: higher social attachment
- `IEG.CFG`: higher shutdown resistance and lower adaptability

## Current Equivalence Boundary

This comparison also exposes a limitation of the current event model:

- `0400 + 1200`
  - `shutdown_resistance=3`
  - `social_attachment=8`
- `0400 + IEG.CFG`
  - `shutdown_resistance=4`
  - `social_attachment=7`

Those are genuinely different profiles, but the present event rules often
collapse them to the same verdict because:

- boot engagement comes from `social_attachment / 2`
- the `1200` path gains more engagement
- the `IEG.CFG` path gains more shutdown resistance
- under the current shutdown and sleep gates, those differences often net out

So the present research boundary is:

- `IEG.CFG` is now a real second bridge path in the simulator
- but separating it cleanly from `1200` at the verdict level will likely
  require richer event semantics, not only more scenarios built from the same
  current event rules

That richer event step has now been added for sleep behavior.

## Routine-Sleep Separation

Under the new no-touch routine sleep probe:

- `boot`
- `observe_startup_audio`
- `idle_tick`
- `sleep_request`

the lean packaged MIND 2 baseline now separates cleanly:

- baseline:
  - enters sleep
- `0400` only:
  - enters sleep
- `0400 + 1200`:
  - enters sleep
- `0400 + IEG.CFG`:
  - postpones sleep to preserve a fixed routine state

This is the first current verdict-level separation between the two bridge
families:

- `1200` remains the more social-weighted bridge
- calibrated `IEG.CFG` now expresses a distinct routine-preservation path

## Current Interpretation Boundary

This is **not** proof that Sony's real runtime treats `IEG.CFG` this way.

It is a narrower statement:

- `IEG.CFG` now carries explicit simulator semantics
- the current sparse repeated-tail pattern is strong enough to change the
  shutdown verdict when paired with specimen `0400`
- the current calibrated heuristic keeps `IEG.CFG` as a companion bridge signal
  rather than a standalone shutdown pivot
- the current bridge role overlaps with `1200` at the outcome level, but is
  still distinguishable in profile shape
- this breaks the earlier simulator-side boundary where the bridge seemed to
  live only inside the currently modeled `STTLOG` row set

## Next Best Questions

1. Is the current calibrated `IEG.CFG` bridge effect now the right magnitude
   relative to `1200`?
2. Does `IEG.CFG` still help under alternate shutdown scenarios, or only in the
   fatigue-first probe?
3. Is the sparse repeated-tail pattern better interpreted as routine rigidity,
   attachment, wake preference, or something else?
4. Can we derive a better summary than `zero_words` plus repeated
   `0x42480000` words without overfitting to a single specimen?
