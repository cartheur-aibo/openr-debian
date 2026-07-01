#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  scripts/decode-retail-connect-suffix.sh <connect-a> <connect-b>
  scripts/decode-retail-connect-suffix.sh --start-byte <offset> <connect-a>

Decode a retail CONNECT.CFG stable suffix as candidate 24-byte records.

Modes:
  pair mode:
    Detect the shared trailing 8-byte-block suffix between <connect-a> and
    <connect-b>, then decode that suffix from <connect-a>.

  explicit mode:
    Decode <connect-a> starting at <offset>.
EOF
}

START_BYTE=

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ "${1:-}" = "--start-byte" ]; then
  if [ "$#" -ne 3 ]; then
    usage
    exit 1
  fi
  START_BYTE=$2
  shift 2
fi

if [ "$#" -ne 1 ] && [ "$#" -ne 2 ]; then
  usage
  exit 1
fi

python3 - "$START_BYTE" "$@" <<'PY'
from pathlib import Path
import struct
import sys

start_arg = sys.argv[1]
paths = [Path(arg) for arg in sys.argv[2:]]

for path in paths:
    if not path.is_file():
        raise SystemExit(f"error: file not found: {path}")

data = [path.read_bytes() for path in paths]

for path, blob in zip(paths, data):
    if len(blob) % 8 != 0:
        raise SystemExit(f"error: file not divisible by 8 bytes: {path}")

if start_arg:
    start = int(start_arg, 0)
    if start < 0 or start > len(data[0]):
        raise SystemExit("error: start byte is out of range")
    mode = "explicit"
else:
    if len(paths) != 2:
        raise SystemExit("error: pair mode requires exactly 2 files")

    a_blocks = [data[0][i:i + 8] for i in range(0, len(data[0]), 8)]
    b_blocks = [data[1][i:i + 8] for i in range(0, len(data[1]), 8)]

    shared_trailing = 0
    for ab, bb in zip(reversed(a_blocks), reversed(b_blocks)):
        if ab != bb:
            break
        shared_trailing += 1

    if shared_trailing == 0:
        raise SystemExit("error: files do not share a trailing 8-byte-block suffix")

    start = len(data[0]) - (shared_trailing * 8)
    mode = "pair"

suffix = data[0][start:]
if len(suffix) == 0:
    raise SystemExit("error: empty suffix")
if len(suffix) % 24 != 0:
    raise SystemExit(
        f"error: suffix length {len(suffix)} is not divisible by 24 bytes"
    )

records = [suffix[i:i + 24] for i in range(0, len(suffix), 24)]
le_rows = [struct.unpack("<6I", rec) for rec in records]
be_rows = [struct.unpack(">6I", rec) for rec in records]
qword_rows = [struct.unpack("<3Q", rec) for rec in records]

print("Retail CONNECT.CFG suffix decode")
print(f"mode: {mode}")
print(f"source: {paths[0]}")
if len(paths) == 2:
    print(f"pair:   {paths[1]}")
print(f"start-byte: {start}")
print(f"end-byte:   {start + len(suffix) - 1}")
print(f"suffix-bytes: {len(suffix)}")
print(f"records-24-byte: {len(records)}")
print()

for index, rec in enumerate(records):
    qwords_hex = [rec[i:i + 8].hex() for i in range(0, 24, 8)]
    le_text = " ".join(str(value) for value in le_rows[index])
    be_text = " ".join(str(value) for value in be_rows[index])
    qword_text = " ".join(f"0x{value:016x}" for value in qword_rows[index])
    print(f"record {index:02d}")
    print(f"  hex24:   {rec.hex()}")
    print(f"  qwords:  {' '.join(qwords_hex)}")
    print(f"  u32le:   {le_text}")
    print(f"  u32be:   {be_text}")
    print(f"  u64le:   {qword_text}")

print()
print("column-uniqueness-u32le:")
for column in range(6):
    values = [row[column] for row in le_rows]
    print(
        f"  col{column}: unique={len(set(values))} "
        f"min={min(values)} max={max(values)}"
    )

print()
print(f"unique-full-records: {len(set(records))}")
PY
