# Behavior Workflow

This is the operational workflow for the first reproducibility phase.

## Goal

Move from:

- "the repaired specimen behaves differently"

to:

- "we know whether that difference transfers with app-state alone, identity
  state, both, or neither"

## Inputs

Specimen image:

- `local-artifacts/sony-mind2-restored-2026-07-01.img`

Reference image:

- `local-artifacts/sony-mind2-reference.img`

## Build Test Trees

Identity-neutral transplant:

```bash
INJECT_LAB_WLAN=1 ./scripts/stage-mind2-behavior-transplant.sh \
  neutral \
  local-artifacts/sony-mind2-restored-2026-07-01.img \
  local-artifacts/sony-mind2-reference.img
```

Identity-sensitive transplant:

```bash
INJECT_LAB_WLAN=1 ./scripts/stage-mind2-behavior-transplant.sh \
  sensitive \
  local-artifacts/sony-mind2-restored-2026-07-01.img \
  local-artifacts/sony-mind2-reference.img
```

These produce staged trees under:

- `features/mind2-behavior-research/build/neutral-stick`
- `features/mind2-behavior-research/build/sensitive-stick`

## Copy To Sacrificial Media

Copy one staged tree at a time to a separate test stick:

```bash
rsync -a --delete /path/to/staged-stick/ /path/to/mounted-stick/
sync
```

Do not overwrite the preserved specimen media.

## Test Order

1. Run the neutral test first.
2. Observe startup, shutdown, wake behavior, and any distinctive cues.
3. Log the result with the observation template.
4. Only then run the sensitive test with `AIBO-ID`.

## Interpretation

- Neutral transfers behavior:
  app-state cluster may be sufficient
- Only sensitive transfers behavior:
  identity binding likely matters
- Neither transfers behavior:
  the current cluster is incomplete, or context matters more than expected

## Required Notes

For every hardware test:

- record which staged tree was used
- record whether lab WLAN was injected
- record the target robot
- record whether the behavior repeated
- record whether the robot still booted normally

## Current Live Matrix

The current bench-facing matrix now lives here:

- [LIVE-HARDWARE-MATRIX-2026-07-01.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/mind2-behavior-research/LIVE-HARDWARE-MATRIX-2026-07-01.md)

Use that note when choosing which prepared sticks to run and in what order.
