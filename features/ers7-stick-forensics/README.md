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

We preserved a raw image of the `CARTE` reference stick here:

- [sony-32mb-reference-carte.img](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7-stick-forensics/sony-32mb-reference-carte.img)
- [sony-32mb-reference-carte.img.sha256](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7-stick-forensics/sony-32mb-reference-carte.img.sha256)

Recorded SHA-256:

```text
de73c765713e95c9cc73e54bb01bbc727ed4bec4a8845e87a931fb5221e2499c
```

When a future session has direct host access to `/dev/sdX`, preserve a raw
image before rewriting the media:

```bash
dd if=/dev/sdX of=features/ers7-stick-forensics/sony-32mb-reference.img bs=1M status=progress
sync
sha256sum features/ers7-stick-forensics/sony-32mb-reference.img
```

If the media is mounted, unmount it cleanly first so the filesystem is not
captured in a dirty state.

## Sony Larger-Capacity Reference Media: MIND 3-Class Stick

We also inspected a larger Sony stick in the `MSAC-US40` reader that strongly
matches the preserved ERS-7 MIND 3 tree in this repo.

Its recorded details live in:

- [mind3-reader-capture.txt](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7-stick-forensics/mind3-reader-capture.txt)

The important observed markers were:

- `MEMSTICK.IND`
- `OPEN-R/BOOTPARA`
- `OPEN-R/APP/OBJS/SA.BIN`
- `OPEN-R/APP/OBJS/STM.BIN`
- `OPEN-R/APP/PC/DIARY`
- `OPEN-R/APP/VERSION`
- `OPEN-R/SYSTEM/VERSION`
- `OPEN-R/MW/VERSION`

This is the same feature combination that distinguishes the preserved
[opt/AIBO7M3](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/opt/AIBO7M3)
tree from the smaller MIND 2 image in this repo.

The larger stick also carried later Mac-side metadata such as:

- `.Spotlight-V100`
- `.Trashes`
- `._*` AppleDouble sidecar files

Those should be treated as later host-side clutter, not as core MIND 3 runtime
content.

Recommended raw image target when direct host access is available:

```bash
dd if=/dev/sdX of=features/ers7-stick-forensics/sony-mind3-reference.img bs=1M status=progress
sync
sha256sum features/ers7-stick-forensics/sony-mind3-reference.img
```

We preserved the raw image of this larger MIND 3-class stick locally at:

- `local-artifacts/sony-mind3-reference.img`
- [sony-mind3-reference.img.sha256](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7-stick-forensics/sony-mind3-reference.img.sha256)

The image is intentionally kept out of normal Git history so the repo can push
to GitHub without Git LFS.

Recorded SHA-256:

```text
5f5eb0948a69107a88a0dd6f6d0c039344add9ef4b2cbf2766404dd1ec5ec545
```

Comparison against the repo's preserved MIND 3 tree showed:

- strong agreement on the core `OPEN-R` MIND 3 identity markers
- a larger-stick layout based on `FAT16` with partition start sector `33`
- no visible `PALM/` or `StikZap.prc` in the captured raw image listing
- significant later Mac metadata on the captured stick

So the current best interpretation is:

- the captured media is very likely a real MIND 3-class runtime/app stick
- it is not an exact file-tree match for `opt/AIBO7M3`
- bootability on the robot remains unproven until hardware test

Recommended changes to bring `opt/AIBO7M3` closer to a stricter AIBO-stick
spec:

- add a strict staging mode that copies only `MEMSTICK.IND` and `OPEN-R/`
- strip `.Spotlight-V100`, `.Trashes`, `._*`, `.DS_Store`, and similar host metadata from staged outputs
- keep `opt/AIBO7M3` as the fuller preserved tree, but stage a stricter hardware-test variant separately
- prefer the captured raw image over the repo tree when resolving authenticity questions about top-level contents
