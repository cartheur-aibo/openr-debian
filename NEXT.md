# Next Session

This note intersects the long-range development intent in [PLAN.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/PLAN.md) with the current MIND 2 behavior-forensics state of the repo.

## Where We Are

Two tracks now coexist:

1. **OPEN-R development track**
   - long-term goal from `PLAN.md`
   - build toward deliberate ERS-7 programming such as the "hello body"
     program
   - learn the OPEN-R object model, deployment path, and sensor/actuator loop

2. **MIND 2 behavior-forensics track**
   - immediate active research track
   - recover, preserve, and compare real MIND 2 persistent state
   - determine whether higher-order behavior is reproducible from filesystem
     state

The current repo is furthest along on the second track.

## What We Have Already Established

- a real Sony-formatted MIND 2 stick was repaired and preserved
- the repaired specimen boots on real hardware
- host-side behavior modeling now separates three current roles:
  - `0400` as a shutdown-side pivot
  - `1200` as socially cued persistence
  - specimen-side `IEG.CFG` as routine-preserving persistence
- four first-pass hardware trial trees are prepared under
  [trials](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/trials)

## WLAN Programming Boundary

The repo now supports a clearer boundary for remote work while the stick is in
the robot:

- MIND 2 and related OPEN-R layouts can expose live WLAN services
- `WCONSOLE` exposes a wireless console on port `59000`
- the stock MIND 2 environment serves web content on port `80`
- the `W3AIBO` sample is designed to serve camera output on port `60080`
- decoded `MMFTP.CFG` indicates bounded network-mediated content channels for
  specific payload families rather than arbitrary filesystem access

This means we should treat WLAN as a way to observe, control, and possibly feed
specific service paths on a running robot, but not as an already-proven method
for freely rewriting the full Sony Memory Stick payload in place.

For the next research phase, that distinction matters: remote services may help
us characterize runtime behavior and persistence, but stick programming and
boot-payload changes should still be treated as separate deployment work unless
we prove otherwise.

## Immediate Next Session Goal

The next session should prioritize **live hardware validation**, not more
simulator expansion.

Why:

- the current simulator now gives us a strong enough distinction to test
- the main uncertainty has shifted from modeling to reproducibility on real
  ERS-7 hardware
- live results will determine whether the current behavioral claims belong in
  the paper as evidence, hypotheses, or simulator-only findings

## Bench Order

Start with the prepared sticks in `trials/`:

1. `01-baseline`
2. `02-0400`
3. `03-0400-plus-1200`
4. `04-0400-plus-ieg`

Use the matrix in
[features/mind2-behavior-research/LIVE-HARDWARE-MATRIX-2026-07-01.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/mind2-behavior-research/LIVE-HARDWARE-MATRIX-2026-07-01.md).

Recommended first run order:

1. Trial A on `01-baseline`
2. Trial A on `02-0400`
3. Trial B on `03-0400-plus-1200`
4. Trial C on `03-0400-plus-1200`
5. Trial A on `04-0400-plus-ieg`
6. Trial B on `04-0400-plus-ieg`

## What We Are Improving

### Short-term

- confidence that the current persistent-state distinctions are real on
  hardware
- confidence that cue salience and repeated pressure matter the way the
  simulator predicts
- disciplined observation records for publication

### Medium-term

- a publishable behavioral-forensics dataset
- a stronger mapping between specific files and specific persistence families
- better criteria for when to refine the simulator versus when to trust the
  bench

### Long-term

- transition from reverse-engineering behavior to designing new behavior
- reconnect the behavior-forensics results to the OPEN-R programming path in
  `PLAN.md`
- eventually use that understanding to build original ERS-7 applications and
  controlled behavior experiments

## Required Artifacts During The Next Session

- one observation record per live run using
  [features/mind2-behavior-research/OBSERVATION-TEMPLATE.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/mind2-behavior-research/OBSERVATION-TEMPLATE.md)
- stick identity and robot identity recorded every time
- whether the behavior survived a second cycle
- whether the outcome changed with cue salience
- whether the robot still booted and operated normally

## Decision Boundary For After The Next Session

After the first hardware pass, decide one of three things:

1. the simulator is tracking reality well enough to keep refining as a serious
   research tool
2. the simulator is only partially aligned, and must be corrected from live
   evidence
3. the live robot does not separate these paths cleanly, which changes the
   paper's claims

## Relation To PLAN.md

`PLAN.md` still matters, but it is not the next bottleneck.

The next bottleneck is empirical:

- can the behavior-forensics results survive contact with real hardware?

If yes, that work becomes a powerful foundation for the OPEN-R programming path
later, because we will understand not only how to deploy code, but also how the
retail system's persistent behavior state appears to work.
