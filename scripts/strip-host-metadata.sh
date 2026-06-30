#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
usage: strip-host-metadata.sh /path/to/stick-tree

Remove common host-side metadata that should not be treated as part of a real
AIBO Memory Stick image.

This currently removes:
- .DS_Store
- .Spotlight-V100
- .Trashes
- .fseventsd
- .TemporaryItems
- ._* AppleDouble sidecar files
EOF
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ "$#" -ne 1 ]; then
  usage
  exit 1
fi

TARGET_DIR="$1"

if [ ! -d "$TARGET_DIR" ]; then
  echo "error: target directory not found: $TARGET_DIR" >&2
  exit 1
fi

find "$TARGET_DIR" \
  \( -name '.DS_Store' -o -name '._*' \) \
  -print -delete

find "$TARGET_DIR" -mindepth 1 -maxdepth 1 \
  \( -name '.Spotlight-V100' -o -name '.Trashes' -o -name '.fseventsd' -o -name '.TemporaryItems' \) \
  -print0 | xargs -0r rm -rf

echo "Stripped host metadata from: $TARGET_DIR"
