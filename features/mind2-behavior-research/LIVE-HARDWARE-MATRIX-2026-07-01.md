# Live Hardware Matrix: July 1, 2026

This note turns the current simulator-side conclusion boundary into a concrete
bench matrix for real ERS-7 testing.

The purpose is not to prove the simulator right. The purpose is to give the
hardware work a disciplined structure that can falsify or refine the current
model quickly.

## Current Dynamic Target

The current host-side reading is:

1. `0400`
   - shutdown-side pivot
2. `1200`
   - socially cued persistence
   - stronger after salient interaction
   - shorter-lived than the routine path
3. specimen-side `IEG.CFG`
   - routine-preserving persistence
   - more durable across repeated pressure

The hardware matrix should test those claims directly.

## Sticks To Prepare

Prepare at least these four sacrificial test sticks:

1. `baseline`
2. `0400`
3. `0400 + 1200`
4. `0400 + IEG`

If media and time allow, also prepare:

5. `IEG transitional 61`

This fifth stick is especially valuable because it tests whether the
transitional routine-strength band has any live analogue or is only a current
simulator convenience.

## Core Trial Families

Run three core families in this order:

1. no-touch routine pressure
2. high-salience social pressure
3. low-salience social pressure

This ordering is intentional:

- first separate routine persistence from everything else
- then ask whether `1200` expresses a distinct social persistence family
- then ask whether that social family is salience-sensitive on real hardware

## Trial A: No-Touch Routine Pressure

### Intent

Test whether the robot preserves an ongoing state when no extra interaction is
added.

### Sequence

1. boot the robot
2. allow a short quiet settling period
3. avoid touch interaction
4. introduce a routine-like interruption or transition pressure
5. observe whether the robot resumes/preserves the current mode or yields
6. repeat once if safe

### Expected Strongest Separator

- `0400 + IEG`
  - more likely to preserve or resume the current mode
- `0400 + 1200`
  - less likely to preserve routine without interaction

## Trial B: High-Salience Social Pressure

### Intent

Test whether socially salient interaction creates a short-lived persistence
effect distinct from routine preservation.

### Sequence

1. boot the robot
2. deliver one salient interaction
   - head touch or similarly strong social cue
3. allow a short idle period
4. apply a disruption or transition pressure
5. repeat the idle/disruption cycle once
6. observe whether the robot stays socially engaged, breaks, or preserves
   routine

### Expected Reading

- `0400 + 1200`
  - should show stronger interaction-seeking persistence than `0400`
  - may sustain one or two short social redirections
- `0400 + IEG`
  - should still look more routine-preserving than socially needy

## Trial C: Low-Salience Social Pressure

### Intent

Test whether the social path weakens when interaction salience is reduced.

### Sequence

1. boot the robot
2. deliver a weaker interaction
   - back touch or calmer nearby-presence cue
3. allow a short idle period
4. apply disruption or transition pressure
5. repeat once
6. observe whether persistence weakens faster than in Trial B

### Expected Reading

- `0400 + 1200`
  - should weaken relative to the high-salience trial
- `0400 + IEG`
  - should remain comparatively stable if the current routine hypothesis is
    right

## Minimal First Pass

If time is tight, run only these six high-value observations:

1. `baseline` on Trial A
2. `0400` on Trial A
3. `0400 + 1200` on Trial B
4. `0400 + 1200` on Trial C
5. `0400 + IEG` on Trial A
6. `0400 + IEG` on Trial B

That is the shortest matrix that still tests:

- shutdown/routine pivot
- social persistence
- salience sensitivity
- routine durability

## Full Recommended Matrix

| Stick | Trial A | Trial B | Trial C |
| --- | --- | --- | --- |
| `baseline` | yes | yes | yes |
| `0400` | yes | yes | yes |
| `0400 + 1200` | yes | yes | yes |
| `0400 + IEG` | yes | yes | yes |
| `IEG transitional 61` | optional | optional | optional |

## Observation Priorities

For each run, prioritize these questions:

1. Did the robot preserve an ongoing state, redirect socially, or simply yield?
2. Did that happen once, or did it survive a second cycle?
3. Did the outcome depend on cue salience?
4. Did the robot still boot and operate normally?

## Falsifiers

The current dynamic model weakens if:

- `0400 + 1200` and `0400 + IEG` look the same across repeated trials
- `0400 + IEG` does not show any stronger routine preservation than `0400`
- high-salience and low-salience `1200` trials are indistinguishable
- identity or battery condition dominates the result more than stick state

## Strengtheners

The current dynamic model strengthens if:

- `0400 + IEG` preserves state more durably than `0400 + 1200`
- `0400 + 1200` looks more socially persistent than `0400`
- `0400 + 1200` weakens when salience is reduced
- the transitional `IEG` stick lands between strong routine preservation and
  no routine preservation
