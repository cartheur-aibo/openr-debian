# Restored MIND 2 Image Note: July 1, 2026

This note records the repaired preserved image created after restoring a
previously non-boot Sony 32 MB class stick and confirming that it booted on a
real ERS-7.

## Artifact

- `local-artifacts/sony-mind2-restored-2026-07-01.img`

Checksum:

- `81fd3c76eaf89d146f2e2d95738ab15cd43192e80acc48609c626bf542bcbdc1`

Repo checksum record:

- [sony-mind2-restored-2026-07-01.img.sha256](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/reference-sticks/sony-mind2-restored-2026-07-01.img.sha256)

## What It Represents

- a Sony-formatted 32 MB class Memory Stick
- restored with the MIND 2 payload
- confirmed to boot on real hardware
- preserved before further experimentation

## Important Scope Note

This image is a preserved working specimen, not the same thing as the
lab-operational staging workflow.

In particular:

- the specimen's own `WLANCONF.TXT` is part of the preserved image state
- the lab testing workflow may instead inject `src/ERS7M2/WLANCONF.TXT`
- those two should not be treated as interchangeable without intent

## Why It Matters

This artifact bridges two goals:

- preserving recovered real-stick state faithfully
- enabling future comparison against lab-prepared or experimentally modified
  MIND 2 media
