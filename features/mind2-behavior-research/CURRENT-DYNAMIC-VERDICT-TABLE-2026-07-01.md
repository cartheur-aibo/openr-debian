# Current Dynamic Verdict Table: July 1, 2026

This note summarizes the current time-based simulator results after the move
from a hard `IEG.CFG` classifier to a graded persistence model.

It focuses on multi-cycle probes rather than one-step verdicts.

## Trees Compared

- `baseline`
  - `features/aibo-mind2/build/stick`
- `0400`
  - `features/mind2-behavior-research/build/aibo-mind2-0400-specimen`
- `0400 + 1200`
  - `features/mind2-behavior-research/build/aibo-mind2-0400-1200-specimen`
- `0400 + IEG`
  - `features/mind2-behavior-research/build/aibo-mind2-0400-plus-ieg`
- `IEG transitional 61`
  - `features/mind2-behavior-research/build/ieg-threshold-scripted/restore-first-61-cells`

## Dynamic Matrix

| Probe | baseline | `0400` | `0400 + 1200` | `0400 + IEG` | `IEG transitional 61` |
| --- | --- | --- | --- | --- | --- |
| `mind2-routine-endurance-probe.scn` | routine broken twice, sleep | routine broken twice, sleep | routine broken twice, sleep | preserves both cycles, stays awake | preserves first cycle, breaks second, sleep |
| `mind2-social-endurance-probe.scn` | routine broken twice, sleep | routine broken twice, sleep | social persistence twice, then sleep | preserves both cycles, stays awake | social redirection once, then breaks, sleep |
| `mind2-low-salience-endurance-probe.scn` | routine broken twice, sleep | routine broken twice, sleep | breaks immediately, sleep | preserves both cycles, stays awake | preserves first cycle, breaks second, sleep |

## Current Reading

### `1200`

- expresses a social persistence family, not a routine-preserving family
- strongest after high-salience `head_touch`
- weaker or absent under lower-salience input
- can now sustain two social-redirection cycles after a strong high-salience cue
- still collapses sooner under lower-salience input

### specimen-side `IEG.CFG`

- expresses a routine-preserving family
- remains stable across repeated disruption pressure
- remains strong even when touch salience is reduced

### transitional `IEG` band

- does not behave like full routine preservation
- does not behave like pure `1200` social persistence either
- currently looks like an intermediate one-cycle durability regime

## Best Current Dynamic Boundary

The repo now supports a stronger time-based distinction than earlier
single-event probes:

1. `1200`
   - socially cued
   - multi-step under high salience, shorter-lived under lower salience
   - salience-sensitive
2. strong specimen-side `IEG.CFG`
   - routine-preserving
   - multi-cycle
   - less dependent on touch salience
3. partial `IEG` restorations
   - intermediate durability bands

This is the best current simulator-side evidence that the two paths are
distinct persistence families rather than cosmetic variants of one behavior.
