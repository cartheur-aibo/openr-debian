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
