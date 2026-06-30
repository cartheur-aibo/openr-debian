# ERS-7 MIND 3 Test Stick Workflow

This workflow mirrors the larger-stick MIND 2 path, but stages the preserved
MIND 3 runtime tree instead.

It is intended for larger original Sony Memory Sticks such as 32 MB or 64 MB
media, where we want a full stock MIND 3 baseline before attempting any custom
overlay work.

## Goal

Prepare a full MIND 3 stick for app testing with:

- the preserved MIND 3 file tree from `opt/AIBO7M3`
- a repo-controlled Wi-Fi config from `src/ERS7M3/WLANCONF.TXT`
- a repeatable staging directory under `features/`

## Build The Staging Tree

Run:

```bash
./scripts/prepare-ers7m3-test-stick.sh
```

For a stricter AIBO-style staging tree that excludes Palm-side extras and
automatically strips macOS host metadata:

```bash
STRICT_AIBO_LAYOUT=1 ./scripts/prepare-ers7m3-test-stick.sh
```

That creates:

- `features/ers7m3-test-stick/build/stick`

and injects:

- [src/ERS7M3/WLANCONF.TXT](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/src/ERS7M3/WLANCONF.TXT)

into:

- `OPEN-R/SYSTEM/CONF/WLANCONF.TXT`

## What It Uses

The script copies from:

- [opt/AIBO7M3](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/opt/AIBO7M3)

which is the preserved MIND 3 stick tree in this repo.

By default, staged output also strips common host-side junk such as:

- `.Spotlight-V100`
- `.Trashes`
- `._*`
- `.DS_Store`

## Copy To The Mounted Stick

Once the Sony stick is mounted:

```bash
rsync -a --delete /home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7m3-test-stick/build/stick/ /path/to/mounted-stick/
sync
```

Then eject the stick cleanly before inserting it into the ERS-7.

## Notes

- this is a stock-runtime staging workflow, not a from-scratch programmable
  stick build
- the default WLAN config matches the repo's proven `AIBONET` baseline so the
  network settings are easy to compare with the MIND 2 path
- if you want the stricter captured-stick shape, set `STRICT_AIBO_LAYOUT=1`
- if you want to preserve the stock MIND 3 WLAN file instead, override
  `WLANCONF_SOURCE`

Example:

```bash
WLANCONF_SOURCE=./opt/AIBO7M3/OPEN-R/SYSTEM/CONF/WLANCONF.TXT \
  ./scripts/prepare-ers7m3-test-stick.sh
```
