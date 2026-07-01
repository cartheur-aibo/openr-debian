# Event Semantics Backlog: July 1, 2026

This note records the next best simulator-side event-model iterations now that
the current filesystem-state work has reached a stronger conclusion boundary.

## Why This Exists

We now know that the current simulator can isolate meaningful profile
differences between:

- `STTLOG` row `1200`
- calibrated specimen-side `IEG.CFG`

But we also learned that many scenarios collapse those differences back into
the same top-line verdict because the current event algebra is still simple.

So the next gains are likely to come from better event semantics rather than
more file swaps alone.

## Current Limitation

Today the model mainly uses:

- boot engagement from `social_attachment / 2`
- fixed `+2` touch engagement
- simple `fatigue += 1` idle decay
- one shutdown threshold
- one sleep threshold

That is enough to expose some structure, but not enough to express richer
distinctions like:

- social clinginess
- routine preservation
- context-sensitive reluctance
- different kinds of wake/sleep hesitation

## Iteration 1: Distinguish Social Touch From Routine Persistence

### Goal

Let social bridge paths and routine bridge paths diverge more naturally after
touch instead of both simply increasing engagement.

### Candidate Change

- add a second internal state such as `routine_hold`
- let `head_touch` primarily boost social engagement
- let sparse `IEG.CFG` primarily reinforce `routine_hold` rather than only
  generic engagement/resistance

### Why It Helps

- `1200` should look more socially persistent
- `IEG.CFG` should look more like preserving a current routine or mode

### Current Status

- implemented in the simulator as a distinct `routine_hold` state
- sparse specimen-side `IEG.CFG` now seeds `routine_rigidity`, which becomes
  `routine_hold` on boot
- `head_touch` reduces `routine_hold` slightly instead of strengthening it
  directly
- current result:
  - `0400 + IEG.CFG` can now diverge from `0400 + 1200` on the
    `mind2-routine-sleep-probe.scn` scenario

## Iteration 2: Different Idle Decay For Social And Routine Paths

### Goal

Make no-touch waiting expose bridge differences without needing hand-tuned
special-case scenarios.

### Candidate Change

- social engagement decays faster than routine hold
- routine hold decays slowly or under different triggers

### Why It Helps

- `1200` paths should weaken more under isolation
- `IEG.CFG` paths should remain more stable in no-touch state-preservation
  situations

### Current Status

- implemented in first-pass form
- `engagement` decays on every `idle_tick`
- sparse-`IEG.CFG` `routine_hold` survives the first idle transition and only
  begins decaying on later idle ticks
- current result:
  - `0400 + IEG.CFG` stays awake and postpones sleep on the
    `mind2-routine-sleep-probe.scn` scenario
  - baseline, `0400`, and `0400 + 1200` still enter sleep under the same
    no-touch probe

## Iteration 3: Separate Shutdown Reluctance From Sleep Reluctance

### Goal

Avoid treating all resistance as one generic "no" behavior.

### Candidate Change

- add separate thresholds or modifiers for:
  - shutdown resistance
  - sleep postponement
  - wake persistence

### Why It Helps

- some paths may resist shutdown but not sleep
- others may preserve routine across sleep transitions more strongly than they
  resist power-off

## Iteration 4: Add A Routine-Decay Event

### Goal

Probe routine preservation directly instead of inferring it only from sleep
behavior.

### Candidate Change

- introduce an event like `schedule_disruption` or `routine_interrupt`
- let sparse `IEG.CFG` respond differently than social-weighted `1200`

### Why It Helps

- creates a more direct behavioral expression for what the current `IEG.CFG`
  heuristic is trying to model

### Current Status

- implemented as `schedule_disruption`
- current result on `mind2-routine-disruption-probe.scn`:
  - `0400 + IEG.CFG`: `verdict: routine state preserved`
  - baseline, `0400`, `0400 + 1200`: `verdict: routine broken`
- this is the cleanest current simulator-side distinction between
  routine-weighted and non-routine-weighted paths

## Iteration 5: Make Touch Type Matter

### Goal

Differentiate between general contact and socially salient interaction.

### Candidate Change

- separate `head_touch`, `back_touch`, and possibly a calmer neutral input
- let `1200` respond more strongly to social-touch salience than `IEG.CFG`

### Why It Helps

- should widen the gap between social-weighted and routine-weighted bridges

### Current Status

- `head_touch` and `back_touch` now diverge explicitly
  - `head_touch` is modeled as `social-high`
  - `back_touch` is modeled as `social-low`
- current result on `mind2-social-disruption-probe.scn`:
  - `0400 + IEG.CFG`
    - `verdict: routine state preserved`
    - sleep postponed, but via retained routine state after disruption
  - `0400 + 1200`
    - `verdict: seek interaction rather than preserve routine`
    - sleep postponed because engagement remains high after `head_touch`
  - `0400`
    - brief social redirection is possible, but sleep still follows
  - baseline
    - routine broken and sleep follows
- current result on `mind2-low-salience-disruption-probe.scn`:
  - `0400 + 1200`
    - still seeks interaction after `back_touch`
    - but no longer retains enough engagement to postpone sleep
  - `0400 + IEG.CFG`
    - still preserves routine and postpones sleep
  - `0400`
    - routine broken and sleep follows
- current result on `mind2-neutral-disruption-probe.scn`:
  - `0400 + 1200`
    - registers nearby presence and briefly redirects into interaction
    - but still enters sleep after disruption
  - `0400 + IEG.CFG`
    - still preserves routine and postpones sleep
  - `0400` and baseline
    - routine broken and sleep follows
- this is the clearest current host-side distinction between:
  - routine-weighted persistence
  - socially salient persistence
  - neutral-cue social sensitivity
  - plain shutdown bias without durable persistence

## Recommended Next Order

1. Extend the routine probe family with multi-cycle pressure.
2. Re-run:
   - `0400 + 1200`
   - `0400 + IEG.CFG`
   - `0400` only
   - `IEG` threshold-window variants
   on the shutdown, fatigue, default, routine-sleep, routine-disruption,
   routine-endurance, social-disruption, low-salience disruption, and
   neutral-disruption probes.
3. Decide whether the next gain comes from more event types or from
   deeper file semantics.

### Current Addendum

- `mind2-routine-endurance-probe.scn` now provides the first useful
  multi-cycle routine-pressure scenario.
- under the graded `IEG` model it exposes:
  - strong routine preservation
  - transitional one-cycle preservation
  - weak/no routine preservation
- this is the clearest current dynamic argument for keeping the gradient model
  instead of the earlier pure hard classifier.
- `mind2-social-endurance-probe.scn` and
  `mind2-low-salience-endurance-probe.scn` now extend that same idea to the
  social side.
- current multi-cycle distinction:
  - `0400 + 1200`
    - shows one-cycle social persistence after `head_touch`
    - but fails by the second disruption and sleeps
    - collapses immediately under the lower-salience endurance probe
  - `0400 + IEG.CFG`
    - preserves routine across both high- and low-salience endurance probes
  - transitional `IEG` variants like `61` restored cells
    - can preserve one cycle
    - but fail on the second cycle

This is the clearest current dynamic separation between:

- socially cued persistence
- routine persistence
- transitional routine strength
