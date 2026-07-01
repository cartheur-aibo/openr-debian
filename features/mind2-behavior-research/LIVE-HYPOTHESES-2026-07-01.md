# Live Hardware Hypotheses: July 1, 2026

This note translates the current simulator-side findings into concrete
live-hardware hypotheses worth testing on real ERS-7 MIND 2 media.

## Purpose

The simulator has now isolated several host-side behavior candidates strongly
enough that we can stop speaking only in generalities.

This note turns those into:

- concrete live expectations
- minimal hardware trials
- clear falsifiable outcomes

## Current Simulator Translation

The current host-side model points to three distinct roles:

1. `STTLOG` row `0400`
   - primary shutdown-side pivot
2. `STTLOG` row `1200`
   - more social-weighted bridge signal
3. `IEG.CFG`
   - more routine-rigidity-weighted bridge signal

The key practical meaning is:

- different persistent-state combinations may produce superficially similar
  "doesn't like to be turned off" behavior for different underlying reasons

That matters for hardware work because the real robot may separate those
reasons more clearly than the current simulator does.

## Hypothesis 1: `0400` Tracks Immediate Shutdown Resistance

### Claim

If specimen-style `0400` is present in otherwise lean MIND 2 state, the robot
should be more likely to resist or delay immediate shutdown attempts than the
same baseline without that row.

### Minimal Live Trial

Compare:

- lean baseline stick
- same baseline with specimen-style `0400` transplanted

### Expected Live Effect If Correct

- less immediate compliance with power-off attempts
- more hesitation, delay, or one-step resistance before powering down

## Hypothesis 2: `1200` Expresses Social Persistence More Than Routine Rigidity

### Claim

If specimen-style `1200` is paired with `0400`, the robot should look more
socially persistent rather than merely mechanically resistant.

### Minimal Live Trial

Compare:

- `0400` only
- `0400 + 1200`

### Expected Live Effect If Correct

- more shutdown resistance after or around interaction
- greater tendency to remain engaged after touch or social stimulation
- less routine-like "hold current state" behavior when no fresh interaction is
  present

## Hypothesis 3: `IEG.CFG` Expresses Routine Preservation More Than Social Pull

### Claim

If specimen-side `IEG.CFG` is paired with `0400`, the robot may resist
shutdown or sleep in a more routine-preserving way than the `1200` path does.

### Minimal Live Trial

Compare:

- `0400 + 1200`
- `0400 + IEG.CFG`

### Expected Live Effect If Correct

- both may resist shutdown
- but the `IEG.CFG` path may look less socially needy and more like
  "staying in its current mode" or refusing a state transition
- the `1200` path may look more engagement-seeking or interaction-sensitive

## Hypothesis 4: No-Touch Sleep Pressure Is A Better Separator Than Touch-Heavy Trials

### Claim

The real robot may separate `1200` and `IEG.CFG` more clearly when we do not
feed it extra touch engagement before requesting sleep-like or stop-like state
transitions.

### Minimal Live Trial

Run two styles of observation:

1. no-touch shutdown/sleep pressure after boot
2. touch-engaged shutdown/sleep pressure after boot

### Expected Live Effect If Correct

- no-touch trials should reveal routine-preservation behavior more clearly
- touch-heavy trials may blur the distinction by making both paths look merely
  more "attached" or socially active

## Hypothesis 5: Routine Disruption Should Separate `IEG.CFG` More Cleanly Than `1200`

### Claim

If the current simulator is pointing in the right direction, a live routine
interruption should make specimen-side `IEG.CFG` look more like preserving an
ongoing mode, while `1200` should not show the same direct routine-preserving
effect on its own.

### Minimal Live Trial

Compare:

- `0400 + 1200`
- `0400 + IEG.CFG`

Then introduce a controlled interruption after boot and a short quiet period:

1. boot normally
2. avoid reinforcing touch interaction
3. interrupt the current activity or expected transition
4. observe whether the robot preserves or abandons the current mode

### Expected Live Effect If Correct

- `0400 + IEG.CFG` should look more like preserving or resuming the current
  routine
- `0400 + 1200` should look less routine-fixed and more likely to drift,
  reorient, or require renewed interaction before showing persistence

## Recommended First Hardware Matrix

If sacrificial media are available, the highest-value first live comparison is:

1. lean baseline
2. `0400` only
3. `0400 + 1200`
4. `0400 + IEG.CFG`

Run each with:

- one no-touch shutdown/sleep observation
- one touch-engaged shutdown/sleep observation
- one no-touch routine-disruption observation if practical

The newer dynamic bench matrix is tracked separately here:

- [LIVE-HARDWARE-MATRIX-2026-07-01.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/mind2-behavior-research/LIVE-HARDWARE-MATRIX-2026-07-01.md)

## What Would Falsify The Current Model

Examples:

- `0400` only shows no stronger shutdown resistance than the lean baseline
- `0400 + 1200` and `0400 + IEG.CFG` are indistinguishable across repeated
  no-touch and touch-engaged live observations
- the real robot reacts in ways dominated by identity or context instead of the
  tested persistent-state changes

## What Would Strengthen The Current Model

Examples:

- `0400` consistently increases immediate shutdown resistance
- `1200` produces more interaction-sensitive persistence
- `IEG.CFG` produces more routine-preserving persistence under no-touch sleep
  pressure
