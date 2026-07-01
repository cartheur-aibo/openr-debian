#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
usage: stage-ieg-window-variants.sh <baseline-tree> <specimen-tree> [output-root]

Create staged trees that keep the specimen-side MIND 2 state but progressively
restore an initial window of IEG.CFG 8-byte cells from the baseline tree.

The current target is the long specimen-side zero-second run beginning at
cell 2 (byte offset 0x50) after the IEG header.

Environment variables:
  IEG_WINDOW_CELLS   Space-separated list of cell counts to restore.
                     Default: "0 16 32 48 64 80 98"
EOF
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  usage
  exit 1
fi

BASELINE_TREE=$1
SPECIMEN_TREE=$2
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT_ROOT="${3:-$ROOT_DIR/features/mind2-behavior-research/build/ieg-window-variants}"
IEG_WINDOW_CELLS="${IEG_WINDOW_CELLS:-0 16 32 48 64 80 98}"

BASE_IG="$BASELINE_TREE/OPEN-R/APP/DATA/P/IEG.CFG"
SPEC_IG="$SPECIMEN_TREE/OPEN-R/APP/DATA/P/IEG.CFG"

if [ ! -f "$BASE_IG" ] || [ ! -f "$SPEC_IG" ]; then
  echo "error: baseline/specimen IEG.CFG not found" >&2
  exit 1
fi

rm -rf "$OUTPUT_ROOT"
mkdir -p "$OUTPUT_ROOT"

for CELLS in $IEG_WINDOW_CELLS; do
  VARIANT_DIR="$OUTPUT_ROOT/restore-first-${CELLS}-cells"
  rm -rf "$VARIANT_DIR"
  cp -a "$SPECIMEN_TREE" "$VARIANT_DIR"
  chmod -R u+w "$VARIANT_DIR"

  python3 - "$BASE_IG" "$SPEC_IG" "$VARIANT_DIR/OPEN-R/APP/DATA/P/IEG.CFG" "$CELLS" <<'PY'
import sys
from pathlib import Path

base_path, spec_path, out_path, cells_str = sys.argv[1:]
cells = int(cells_str)
start_cell = 2
cell_size = 8
body_offset = 0x40
start = body_offset + start_cell * cell_size
end = start + cells * cell_size

base = bytearray(Path(base_path).read_bytes())
spec = bytearray(Path(spec_path).read_bytes())
patched = bytearray(spec)
patched[start:end] = base[start:end]
Path(out_path).write_bytes(patched)
PY

  cat > "$VARIANT_DIR/IEG-WINDOW-VARIANT.txt" <<EOF
IEG window restoration variant

Baseline tree: $BASELINE_TREE
Specimen tree: $SPECIMEN_TREE
Restored cells: $CELLS
Restored cell range: 2..$((CELLS + 1))
Restored byte range: 0x$(printf '%x' $((0x50)))..0x$(printf '%x' $((0x50 + CELLS * 8 - 1)))
Method: copy baseline IEG.CFG cells over specimen IEG.CFG in the long zero-run region
EOF
done

echo "Prepared IEG window variants under: $OUTPUT_ROOT"
