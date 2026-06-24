#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
usage: stage-aibo-mind2.sh [source-stick-dir] [/path/to/staging-dir]

Create a staged AIBO MIND 2 Memory Stick layout from either:
- the bundled ERS-7 dump in opt/AIBO7M2
- a mounted real Memory Stick directory

By default, build outputs live under features/aibo-mind2/.

This copies:
  <source>/MEMSTICK.IND
  <source>/OPEN-R/
  <source>/PALM/
  <source>/StikZap.prc

into the target directory so it can be written to a compatible Memory Stick.
EOF
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ "$#" -gt 2 ]; then
  usage
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FEATURE_DIR="$ROOT_DIR/features/aibo-mind2"
BUNDLED_SOURCE_DIR="$ROOT_DIR/opt/AIBO7M2"

if [ "$#" -ge 1 ]; then
  SOURCE_DIR="$1"
else
  SOURCE_DIR="${SOURCE_DIR:-$BUNDLED_SOURCE_DIR}"
fi

if [ "$#" -ge 2 ]; then
  TARGET_DIR="$2"
else
  TARGET_DIR="$FEATURE_DIR/build/stick"
fi

if [ ! -d "$SOURCE_DIR/OPEN-R" ]; then
  echo "error: source AIBO MIND 2 tree not found at $SOURCE_DIR" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"

echo "Staging AIBO MIND 2 from:"
echo "  $SOURCE_DIR"
echo "to:"
echo "  $TARGET_DIR"

rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"

cp -a "$SOURCE_DIR/MEMSTICK.IND" "$TARGET_DIR/"
cp -a "$SOURCE_DIR/OPEN-R" "$TARGET_DIR/"

if [ -d "$SOURCE_DIR/PALM" ]; then
  cp -a "$SOURCE_DIR/PALM" "$TARGET_DIR/"
fi

if [ -f "$SOURCE_DIR/StikZap.prc" ]; then
  cp -a "$SOURCE_DIR/StikZap.prc" "$TARGET_DIR/"
fi

SIZE_BYTES="$(du -sb "$TARGET_DIR" | awk '{print $1}')"
SIZE_MB="$(awk -v bytes="$SIZE_BYTES" 'BEGIN { printf "%.2f", bytes / (1024 * 1024) }')"

echo
echo "Staged size: ${SIZE_MB} MiB"
echo "Note: the bundled AIBO MIND 2 image is larger than an 8 MiB Memory Stick."
echo "Use a larger stick unless you have a verified trimmed layout."
