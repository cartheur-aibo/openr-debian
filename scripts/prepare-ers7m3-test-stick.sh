#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
usage: prepare-ers7m3-test-stick.sh [/path/to/output-dir]

Prepare a full ERS-7 AIBO MIND 3 test-stick staging tree for larger Sony
Memory Sticks such as 32 MB or 64 MB media.

By default this:
- copies the preserved MIND 3 stick tree from opt/AIBO7M3
- replaces OPEN-R/SYSTEM/CONF/WLANCONF.TXT with src/ERS7M3/WLANCONF.TXT
- writes the result under features/ers7m3-test-stick/build/stick

Environment variables:
  SOURCE_STICK_DIR  Source staged stick tree.
                    Default: ./opt/AIBO7M3
  WLANCONF_SOURCE   WLAN config to inject.
                    Default: ./src/ERS7M3/WLANCONF.TXT
EOF
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ "$#" -gt 1 ]; then
  usage
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_STICK_DIR="${SOURCE_STICK_DIR:-$ROOT_DIR/opt/AIBO7M3}"
WLANCONF_SOURCE="${WLANCONF_SOURCE:-$ROOT_DIR/src/ERS7M3/WLANCONF.TXT}"
FEATURE_DIR="$ROOT_DIR/features/ers7m3-test-stick"
OUTPUT_DIR="${1:-$FEATURE_DIR/build/stick}"
COPY_NOTE_FILE="$FEATURE_DIR/build/COPY_TO_MS.txt"

require_path() {
  if [ ! -e "$1" ]; then
    echo "error: missing required path: $1" >&2
    exit 1
  fi
}

require_path "$SOURCE_STICK_DIR/OPEN-R"
require_path "$SOURCE_STICK_DIR/MEMSTICK.IND"
require_path "$WLANCONF_SOURCE"

rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

cp -a "$SOURCE_STICK_DIR/." "$OUTPUT_DIR/"
chmod -R u+w "$OUTPUT_DIR"
cp -a "$WLANCONF_SOURCE" "$OUTPUT_DIR/OPEN-R/SYSTEM/CONF/WLANCONF.TXT"

SIZE_BYTES="$(du -sb "$OUTPUT_DIR" | awk '{print $1}')"
SIZE_MIB="$(awk -v bytes="$SIZE_BYTES" 'BEGIN { printf "%.2f", bytes / (1024 * 1024) }')"

cat > "$COPY_NOTE_FILE" <<EOF
ERS-7 MIND 3 full-stick copy notes

Source stick dir: $SOURCE_STICK_DIR
Injected WLANCONF: $WLANCONF_SOURCE
Stick staging dir: $OUTPUT_DIR

Copy this full staged tree to the root of a mounted larger Sony Memory Stick:

- MEMSTICK.IND
- OPEN-R/
- PALM/
- StikZap.prc (if present)

Example:

  rsync -a --delete "$OUTPUT_DIR"/ /path/to/mounted-stick/
  sync

After copying:

1. Eject/unmount the stick cleanly.
2. Insert it into the ERS-7 while powered off.
3. Boot the robot.
4. Join the same Wi-Fi network from the host machine.
5. Probe the robot over Wi-Fi.
EOF

echo "Prepared ERS-7 MIND 3 test stick at: $OUTPUT_DIR"
echo "Source stick dir: $SOURCE_STICK_DIR"
echo "Injected WLANCONF: $WLANCONF_SOURCE"
echo "Size: ${SIZE_MIB} MiB (${SIZE_BYTES} bytes)"
echo "Copy note: $COPY_NOTE_FILE"
