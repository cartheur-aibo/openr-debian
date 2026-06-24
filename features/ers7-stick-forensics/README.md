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
