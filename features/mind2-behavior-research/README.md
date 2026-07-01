# MIND 2 Behavior Research

This area is the pivot from stick recovery into behavior forensics.

The repo's original stick-making question is now closed enough for normal
operations:

- we can identify Sony-formatted sticks
- we can distinguish non-boot from bootable MIND 2 media
- we can restore a missing MIND 2 payload onto valid Sony media
- we can preserve repaired working sticks as raw images

The next fundamental question is different:

- where do higher-order MIND 2 behaviors live in persistent stick state, and
  are those behaviors reproducible?

## Mission

Treat a working preserved MIND 2 image as a behavioral specimen and build a
repeatable workflow to:

1. describe observed behaviors precisely
2. map candidate behaviors to persistent files
3. test reproducibility with one-variable changes

## Current Baseline Specimen

The most important current artifact is the repaired preserved image:

- `local-artifacts/sony-mind2-restored-2026-07-01.img`

Its checksum record is:

- [sony-mind2-restored-2026-07-01.img.sha256](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/reference-sticks/sony-mind2-restored-2026-07-01.img.sha256)

This specimen is especially valuable because it:

- boots on real hardware
- exhibits behavior noted as different from comparison MIND 2 sticks
- likely carries persistent state worth isolating and studying

## Research Loop

### 1. Observe

Use a stable note format and write down behavior in concrete terms:

- startup sequence
- shutdown resistance or compliance
- wake/sleep transitions
- responsiveness to touch, sound, and interaction
- signs of personality, routine, or owner/environment preference

Start with:

- [OBSERVATION-TEMPLATE.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/mind2-behavior-research/OBSERVATION-TEMPLATE.md)

### 2. Map

Use preserved images and extracted trees to identify candidate files:

- persistent config
- logs
- state variables
- owner/environment data
- larger binary state containers

Start with:

- [CANDIDATE-FILES.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/mind2-behavior-research/CANDIDATE-FILES.md)

### 3. Test

Clone the baseline image to separate test media and change one file or one
small file group at a time.

Rules:

- preserve the original working baseline image unchanged
- do not change more than one variable between tests
- log the exact file delta for every trial
- distinguish reproducible behavior from one-off observation

## Research Questions

The current front-door questions live here:

- [QUESTIONS.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/mind2-behavior-research/QUESTIONS.md)

## Experimental Workflow

The first operational transplant workflow now lives here:

- [WORKFLOW.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/mind2-behavior-research/WORKFLOW.md)
- [CONCLUSION-BOUNDARY.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/mind2-behavior-research/CONCLUSION-BOUNDARY.md)

Supporting tools and notes:

- [scripts/compare-mind2-persistent-state.sh](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/scripts/compare-mind2-persistent-state.sh)
- [scripts/compare-sttlog.sh](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/scripts/compare-sttlog.sh)
- [scripts/stage-mind2-behavior-transplant.sh](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/scripts/stage-mind2-behavior-transplant.sh)
- [scripts/analyze-retail-objectcfg.sh](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/scripts/analyze-retail-objectcfg.sh)
- [scripts/analyze-retail-connect-table.sh](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/scripts/analyze-retail-connect-table.sh)
- [BASELINE-SIMULATOR.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/mind2-behavior-research/BASELINE-SIMULATOR.md)
- [INITIAL-COMPARISON-2026-07-01.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/mind2-behavior-research/INITIAL-COMPARISON-2026-07-01.md)
- [SUSPECT-DOSSIER-2026-07-01.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/mind2-behavior-research/SUSPECT-DOSSIER-2026-07-01.md)
- [AIBO-ID-NOTE-2026-07-01.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/mind2-behavior-research/AIBO-ID-NOTE-2026-07-01.md)
- [EXPERIMENT-DESIGN-IDENTITY-2026-07-01.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/mind2-behavior-research/EXPERIMENT-DESIGN-IDENTITY-2026-07-01.md)
- [OBJECT-CFG-NOTE-2026-07-01.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/mind2-behavior-research/OBJECT-CFG-NOTE-2026-07-01.md)
- [CONNECT-CFG-SUFFIX-NOTE-2026-07-01.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/mind2-behavior-research/CONNECT-CFG-SUFFIX-NOTE-2026-07-01.md)

## Why This Matters

This is the deeper milestone behind the repo:

- not just creating bootable sticks
- but understanding how meaningful MIND 2 behavior is represented in
  filesystem state and how far it can be preserved, reproduced, or modified
