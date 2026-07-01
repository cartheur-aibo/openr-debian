# ERS-7 MIND 2 Test Stick Workflow

This workflow is for larger original Sony Memory Sticks such as the 64 MB
sticks you ordered.

It avoids the 8 MB bring-up path entirely and instead starts from the preserved
known-good AIBO MIND 2 stick tree we captured from the real robot.

## Goal

Prepare a full MIND 2 stick for app testing with:

- the known-good MIND 2 file tree
- the lab-operational Wi-Fi config from `src/ERS7M2/WLANCONF.TXT`
- a repeatable staging directory under `features/`

## Build The Staging Tree

Run:

```bash
./scripts/prepare-ers7m2-test-stick.sh
```

That creates:

- `features/ers7m2-test-stick/build/stick`

and injects:

- [src/ERS7M2/WLANCONF.TXT](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/src/ERS7M2/WLANCONF.TXT)

into:

- `OPEN-R/SYSTEM/CONF/WLANCONF.TXT`

## What It Uses

The script copies from:

- [features/aibo-mind2/build/stick](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/aibo-mind2/build/stick)

which is the preserved staged copy of the known-good 32 MB MIND 2 stick.

This means the 64 MB workflow starts from the best source of truth we have in
the repo.

## WLAN Scope

The repo currently has two different valid WLAN contexts and they should not be
mixed up:

- `features/aibo-mind2/build/stick/OPEN-R/SYSTEM/CONF/WLANCONF.TXT`
  belongs to the preserved specimen-style MIND 2 baseline and may reflect the
  state that came from the preserved stick itself
- `src/ERS7M2/WLANCONF.TXT`
  is the lab-operational config used to prepare test sticks for the current
  shared environment

This workflow intentionally injects `src/ERS7M2/WLANCONF.TXT` because it is for
testing and development in the lab, not for preserving a historical specimen
unchanged.

## Hostname Naming Convention

`src/ERS7M2/WLANCONF.TXT` currently uses:

- `HOSTNAME=AIBO`

That is not descriptive enough for the current lab setup. With multiple ERS-7
units, especially more than one MIND 2 robot, the repo should treat hostnames
as per-robot identity rather than a shared default.

The current intended naming convention is:

- `AIBO-M2A`
- `AIBO-M2B`
- `AIBO-M3A`

Future work should likely define per-robot WLAN variants built from that
convention rather than assuming one shared hostname forever.

## Copy To The 64 MB Stick

Once the 64 MB Sony stick is mounted:

```bash
rsync -a --delete /home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7m2-test-stick/build/stick/ /path/to/mounted-stick/
sync
```

Then eject the stick cleanly before inserting it into the ERS-7.

## Why This Is The Preferred Path

- the full MIND 2 layout already works on the robot
- `Aibonet` is already proven live on the working 32 MB stick
- the new 64 MB sticks remove the 8 MB capacity pressure
- this is the cleanest path for testing real apps without fighting low-level
  8 MB media behavior

## Verified Milestone

We now have a verified live network result with the real robot:

- the ERS-7 joined a compatible mobile-hotspot `AIBONET`
- the robot obtained IP `192.168.43.8`
- this machine reached the robot over Wi-Fi
- `ping 192.168.43.8` succeeded
- `http://192.168.43.8/` responded with:
  `Server: AIBO HTTPD v1.14 (Aperios)`
- the top page identified itself as `AIBO MIND 2 | Top Page`

This is the strongest networking proof we have so far. It confirms:

- the robot can join a compatible access point as a client
- the lab `WLANCONF.TXT` in `src/ERS7M2/WLANCONF.TXT` is a credible operational
  baseline
- earlier failures were strongly influenced by access-point compatibility, not
  just stick contents

One important caveat:

- port `59000` was still closed during this test, so this proved MIND 2 HTTP
  reachability, not the OPEN-R wireless console

## Next App-Test Step

Once the 64 MB stick boots reliably, the next work should be:

1. decide where app payloads should live in the MIND 2 tree
2. define a safe overlay workflow for testing new binaries and configs
3. keep the preserved known-good base intact and layer app changes on top
