# ERS-7 Stick Forensics

This note captures the low-level differences between:

- the recreated 8 MB programming stick
- the known-good 32 MB AIBO MIND 2 stick

The goal is to separate "generic FAT12 that Linux accepts" from "the exact
kind of low-level media layout the robot may actually accept."

## Big Finding

Both sticks are valid FAT12 disks, but they are not formatted the same way.

That matters because the robot rejected the recreated 8 MB stick even after:

- correct `FAT12` geometry for an 8 MB Sony-era stick
- a clean `OPEN-R` + `MEMSTICK.IND` layout
- a minimal SDK base
- a runtime-derived ERS-7 `SYSTEM/` hybrid base

So the remaining likely problem is no longer "wrong files only." It is likely
the physical media itself or the exact Sony low-level formatting style.

## 8 MB Recreated Stick

Observed on the experimental 8 MB stick:

```text
Disk size:       7.73 MiB
Partition start: 25
Partition type:  FAT12
Sector size:     512
Cluster size:    8192
Reserved:        1
FATs:            2
FAT size:        3 sectors
Root entries:    512
Heads:           2
Hidden sectors:  25
Total sectors:   15783
Boot sector OEM: "mkfs.fat"
Jump bytes:      eb 3c 90
MBR disk id:     0xa656bfe7
```

## 32 MB Known-Good Stick

Observed on the working 32 MB AIBO MIND 2 stick:

```text
Disk size:       30.97 MiB
Partition start: 19
Partition type:  FAT12
Sector size:     512
Cluster size:    16384
Reserved:        1
FATs:            2
FAT size:        6 sectors
Root entries:    512
Heads:           4
Hidden sectors:  19
Total sectors:   63341
Boot sector OEM: binary-looking / nonstandard
Jump bytes:      e9 00 00
MBR disk id:     0x00000000
```

## What Is Meaningfully Different

The known-good 32 MB stick differs from the recreated 8 MB stick in these
important low-level ways:

- different partition start sector: `19` vs `25`
- different cluster size: `16 KB` vs `8 KB`
- different geometry: `4` heads vs `2`
- different FAT size: `6` sectors vs `3`
- different boot sector style
- different jump bytes in the partition boot record
- different MBR disk identifier behavior

These are not just "capacity changed" differences. They show that the real
Sony-prepared stick is not formatted like a normal `mkfs.fat` output.

## What We Learned

1. AIBO may care about more than "valid FAT12."
2. Linux-visible FAT metadata was not enough to reproduce the behavior of the
   known-good stick.
3. The recreated 8 MB stick looks sane to Linux, but still does not behave
   like the real Sony-prepared media at the raw-sector level.

## Next Best Step

If the goal is to get to a bootable result fastest, the next best direction is:

1. use the actual known-good 32 MB stick as the source of truth
2. preserve its raw layout and staged file tree
3. prefer cloning or raw-layout imitation over more file-tree-only changes

If the goal stays focused on the 8 MB stick specifically, the next phase should
be sector-level comparison and reproduction, not more `OPEN-R` payload changes.

## Sony 32 MB Reference Media: `CARTE`

We also captured a second Sony-prepared 32 MB stick that is useful as a
formatting reference even though it is not an AIBO boot stick yet.

Its recorded details live in:

- [32mb-carte-capture.txt](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7-stick-forensics/32mb-carte-capture.txt)

The important conclusion is that this media matches the same Sony low-level
formatting pattern as the working 32 MB AIBO MIND 2 stick:

- `dos` MBR
- bootable `FAT12` partition
- start sector `19`
- partition size `63341` sectors
- `16 KB` clusters
- `6` sectors per FAT
- `4` heads
- `19` hidden sectors
- partition jump bytes `e9 00 00`
- MBR disk identifier `0x00000000`

Unlike the working MIND 2 stick, this one currently contains only:

- `MEMSTICK.IND`
- `PALM/`
- Palm launcher files

and does not contain `OPEN-R/`.

That makes it a strong "Sony formatting reference" for future work on blank or
unformatted sticks.

## Raw Image Preservation

We preserved the raw image of the `CARTE` reference stick locally at:

- `local-artifacts/sony-32mb-reference-carte.img`
- [sony-32mb-reference-carte.img.sha256](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7-stick-forensics/sony-32mb-reference-carte.img.sha256)

The image is intentionally kept out of normal Git history for consistency with
the larger MIND 3 reference image.

Recorded SHA-256:

```text
de73c765713e95c9cc73e54bb01bbc727ed4bec4a8845e87a931fb5221e2499c
```

When a future session has direct host access to `/dev/sdX`, preserve a raw
image before rewriting the media:

```bash
dd if=/dev/sdX of=local-artifacts/sony-32mb-reference-carte.img bs=1M status=progress
sync
sha256sum local-artifacts/sony-32mb-reference-carte.img
```

If the media is mounted, unmount it cleanly first so the filesystem is not
captured in a dirty state.

## Genuine Stick Baselines

The active baseline records for genuine MIND 2 and MIND 3 sticks now live in:

- [features/reference-sticks/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/reference-sticks/README.md)

This `ers7-stick-forensics` folder should now be read mainly as:

- the low-level formatting/background record
- the history of why the 8 MB recreation path was deprioritized
- the place for the smaller Sony `CARTE` formatting-reference media
