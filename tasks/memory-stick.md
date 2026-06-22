# Memory Stick workflow

Use a dedicated AIBO-programming Memory Stick.

Do **not** overwrite your working AIBO MIND 2 stick.

## Conceptual layout

The exact layout depends on Sony's OPEN-R installation process and base system files, but a development stick typically contains an `OPEN-R` tree with system configuration, object binaries, and application metadata.

This repo includes a placeholder tree:

```text
stick/OPEN-R/
├── APP/PC/
├── MW/OBJS/
└── SYSTEM/conf/
```

## Deployment pattern

1. Build object binary on Debian.
2. Mount Memory Stick.
3. Copy built object into the appropriate `OPEN-R` object/application path.
4. Sync and unmount.
5. Insert stick into ERS-7.
6. Boot robot.

Example:

```bash
./scripts/deploy-to-stick.sh /media/$USER/AIBO_STICK src/hello_body/build/HelloBody.bin
```

## Safety

- Pause/power down AIBO before removing media.
- Keep backup images of every working stick.
- Never test walking/motion code on a table.
- Start with LEDs and head motions before leg actuation.
