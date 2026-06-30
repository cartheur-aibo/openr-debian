# ERS-7 Reference Sticks

This folder is the current baseline for preserved real-stick knowledge.

Use it when you want the best known reference records for genuine ERS-7 stick
images, not the older forensic narrative about the failed 8 MB recreation
path.

## What Lives Here

- [mind2-reader-capture.txt](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/reference-sticks/mind2-reader-capture.txt)
  for the genuine ERS-7 MIND 2 stick record
- [mind3-reader-capture.txt](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/reference-sticks/mind3-reader-capture.txt)
  for the larger MIND 3-class stick record
- [sony-mind2-reference.img.sha256](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/reference-sticks/sony-mind2-reference.img.sha256)
  for the genuine MIND 2 raw-image digest
- [sony-mind3-reference.img.sha256](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/reference-sticks/sony-mind3-reference.img.sha256)
  for the MIND 3 raw-image digest
- [mind2-imaging.txt](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/reference-sticks/mind2-imaging.txt)
  for the operator command set to inspect and capture a genuine MIND 2 stick
- [mind3-imaging.txt](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/reference-sticks/mind3-imaging.txt)
  for the operator command set to capture a MIND 3-class stick

## Local Raw Images

The raw images themselves are intentionally kept out of Git history and stored
locally under:

- `local-artifacts/sony-mind2-reference.img`
- `local-artifacts/sony-mind3-reference.img`
- `local-artifacts/sony-32mb-reference-carte.img`

This keeps the repo pushable on normal GitHub without Git LFS while preserving
checksums and reference notes online.

## Relationship To Stick Forensics

[features/ers7-stick-forensics/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7-stick-forensics/README.md)
is now the historical/background record for low-level formatting differences
and the deprioritized 8 MB path.

This folder is the active reference baseline.
