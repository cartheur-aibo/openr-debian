# New Sticks Playbook

This is the handoff document for the next phase of ERS-7 work with newly
arrived original Sony Memory Sticks such as 64 MB media.

It captures the strongest conclusions from this session so another agent can
start from the right baseline without repeating dead ends.

Operational troubleshooting lives here:

- [features/new-sticks-playbook/TROUBLESHOOTING.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/new-sticks-playbook/TROUBLESHOOTING.md)

## Mission

Use larger original Sony sticks to:

1. keep a reproducible known-good MIND 2 boot path
2. test app overlays safely
3. test programmable-stick samples such as camera serving

## Closure

The original "can we make a working stick?" question is now closed enough for
future agents to treat it as solved operationally.

What is now established:

- a Sony 32 MB class stick with correct low-level formatting can be preserved
  as raw media
- a non-boot Sony-formatted stick can be diagnosed from its image contents
- a missing `OPEN-R/` plus missing `MEMSTICK.IND` explains the unhappy
  startup-and-power-off behavior
- the repo now contains a repeatable scan workflow and restore workflow
- a restored stick has been proven to boot on real hardware
- the repaired working stick has been preserved as its own raw image

The practical result is:

- a future user or agent should not need to rediscover stick-making from
  scratch
- they should start from the provided tools and preserved reference artifacts
  instead

Canonical tools for that closed problem:

- [scripts/scan-sony-stick-image.sh](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/scripts/scan-sony-stick-image.sh)
- [scripts/restore-mind2-stick.sh](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/scripts/restore-mind2-stick.sh)
- [features/aibo-mind2/RESTORE-SONY-32MB-STICK.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/aibo-mind2/RESTORE-SONY-32MB-STICK.md)
- [features/reference-sticks/MILESTONE-2026-07-01-mind2-recovery.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/reference-sticks/MILESTONE-2026-07-01-mind2-recovery.md)
- [features/reference-sticks/REPAIRED-MIND2-PRESERVATION.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/reference-sticks/REPAIRED-MIND2-PRESERVATION.md)
- [features/reference-sticks/sony-mind2-restored-2026-07-01.img.sha256](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/reference-sticks/sony-mind2-restored-2026-07-01.img.sha256)

## What Is Already Proven

These points are no longer guesses:

- the real ERS-7 can join a compatible Wi-Fi network
- a compatible mobile hotspot named `AIBONET` worked
- the robot came up at `192.168.43.8`
- this machine reached the robot over Wi-Fi
- `ping 192.168.43.8` succeeded
- `http://192.168.43.8/` returned `AIBO HTTPD v1.14 (Aperios)`
- the web UI identified itself as `AIBO MIND 2 | Top Page`

This means:

- the lab robot-side WLAN configuration in
  [src/ERS7M2/WLANCONF.TXT](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/src/ERS7M2/WLANCONF.TXT)
  is a credible operational baseline
- access-point compatibility matters a lot
- the 8 MB failures should not be treated as proof that our higher-level app
  workflows are wrong

## What Is Not Proven

These are still open:

- that a newly prepared 64 MB stick boots in this specific robot
- that we can safely overlay custom app payloads on top of a cloned MIND 2 tree
- that `WCONSOLE` port `59000` is reachable in our current setup
- that `W3AIBO` camera serving works end-to-end on the robot

## Hard-Won Lessons

These lessons should guide all future work:

- Do not prioritize the 8 MB path right now.
- Do not assume a router guest network is compatible just because the ESSID
  matches.
- Do not mix up stock MIND 2 HTTP on port `80` with programmable-stick
  `WCONSOLE` or `W3AIBO` behavior.
- Do not treat a generic `mkfs.fat` recreation as equivalent to a Sony-prepared
  Memory Stick layout.
- Do use the preserved real-stick tree as the baseline whenever possible.

## Canonical Sources Of Truth

When a future agent needs the best known inputs, start here:

- [features/aibo-mind2/build/stick](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/aibo-mind2/build/stick)
  is the preserved staged copy of the real known-good 32 MB ERS-7 MIND 2 stick
- [src/ERS7M2/WLANCONF.TXT](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/src/ERS7M2/WLANCONF.TXT)
  is the lab-operational WLAN config used for current multi-robot testing, not
  necessarily the preserved specimen WLAN state
- the intended hostname naming convention for the current lab is:
  `AIBO-M2A`, `AIBO-M2B`, `AIBO-M3A`
- [features/ers7m2-test-stick/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7m2-test-stick/README.md)
  describes the larger-stick MIND 2 workflow
- [features/ers7m3-test-stick/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7m3-test-stick/README.md)
  describes the larger-stick MIND 3 workflow
- [features/reference-sticks/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/reference-sticks/README.md)
  is the active baseline for preserved genuine MIND 2 and MIND 3 stick records
- [features/ers7-camera-stream/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7-camera-stream/README.md)
  describes the programmable camera-serving workflow
- [features/ers7-stick-forensics/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7-stick-forensics/README.md)
  captures the low-level background and why the 8 MB recreation path was deprioritized

## Phase 1: First Bring-Up On New Sticks

Use this phase first. Do not start with custom apps.

### Goal

Boot a larger original Sony stick with the preserved MIND 2 tree and confirm
the robot joins Wi-Fi and serves the stock HTTP UI.

### Build

Run:

```bash
./scripts/prepare-ers7m2-test-stick.sh
```

This produces:

- `features/ers7m2-test-stick/build/stick`

### Copy To The Mounted Stick

```bash
rsync -a --delete /home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7m2-test-stick/build/stick/ /path/to/mounted-stick/
sync
```

### Test Order

1. Eject the stick cleanly.
2. Insert it into the ERS-7 while powered off.
3. Boot the robot.
4. Put the host machine on the same compatible Wi-Fi network.
5. Find the robot IP from the hotspot/router.
6. Test `ping`.
7. Test `http://AIBO_IP/`.

### Success Criteria

- robot boots normally
- robot joins Wi-Fi
- host can reach the robot
- stock MIND 2 page opens

If this fails, stop and debug that before trying custom payloads.

## Phase 2: Safe App-Overlay Workflow

Only start this once Phase 1 is stable.

### Goal

Add one controlled application change on top of a known-good MIND 2 baseline,
not a from-scratch stick.

### Rules

- keep `features/aibo-mind2/build/stick` unchanged as the preserved baseline
- make overlays in a separate feature folder
- change one thing at a time
- record exactly which files were replaced

### Good First Overlay Targets

- config-only changes
- one object binary plus matching config entry
- a copied sample with minimal surrounding edits

## Phase 3: Programmable Camera Stream

This is the most interesting near-term app target once larger media is proven.

### Goal

Boot the `W3AIBO` sample and fetch images from:

- `http://AIBO_IP:60080/`
- `http://AIBO_IP:60080/layerhr`

### Build

Run:

```bash
JPEG_ARCHIVE=install/jpegsrc.v6b.tar.gz ./scripts/prepare-ers7-camera-stream.sh
```

This produces:

- `features/ers7-camera-stream/build/stick`

### What We Already Know

This workflow has already been built successfully on the host:

- `W3AIBO.BIN` builds
- `POWERMON.BIN` builds
- the stick staging tree is produced

So the remaining unknown is robot/media behavior, not the basic host build.

## Recommended Order For The Next Agent

If a future agent opens this repo cold, the best order is:

1. Read this playbook.
2. Read [features/new-sticks-playbook/TROUBLESHOOTING.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/new-sticks-playbook/TROUBLESHOOTING.md).
3. Read [features/ers7m2-test-stick/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7m2-test-stick/README.md).
4. Verify the preserved baseline exists at
   [features/aibo-mind2/build/stick](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/aibo-mind2/build/stick).
5. Prepare the larger-stick MIND 2 tree.
6. Test stock boot and stock HTTP first.
7. Only then move to app overlays or `W3AIBO`.

## Minimal Command Set

Prepare the known-good MIND 2 staging tree:

```bash
./scripts/prepare-ers7m2-test-stick.sh
```

Prepare the camera-stream staging tree:

```bash
JPEG_ARCHIVE=install/jpegsrc.v6b.tar.gz ./scripts/prepare-ers7-camera-stream.sh
```

Copy a staged tree to a mounted stick:

```bash
rsync -a --delete /path/to/staged-stick/ /path/to/mounted-stick/
sync
```

## Definition Of The Next Big Milestone

The next big milestone is no longer merely "the new stick mounts" or even
"the stick boots."

It is this:

- distinctive higher-order MIND 2 behavior is preserved on real media
- that behavior can be described precisely
- candidate persistent-state files can be identified
- one-variable tests can show whether the behavior is reproducible or unique

That next phase now lives in:

- [features/mind2-behavior-research/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/mind2-behavior-research/README.md)
