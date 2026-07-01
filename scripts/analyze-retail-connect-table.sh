#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/analyze-retail-connect-table.sh <mind2-connect-cfg> <mind3-connect-cfg> [mw-objs-dir]

Analyze retail MW CONNECT.CFG files as:

- an 8-byte prelude
- followed by aligned 24-byte records

The tool labels each aligned record as:

- stable: same 24-byte record at the same index in both files
- versioned: different record at the same index

If a MW object directory is supplied, or if one can be inferred from the
neighboring tree, the tool also reports the MW object count alongside the
stable/versioned partition.
EOF
}

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ] || [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit $([ "$#" -ge 2 ] && [ "${1:-}" != "-h" ] && [ "${1:-}" != "--help" ] && echo 0 || echo 1)
fi

python3 - "$@" <<'PY'
from pathlib import Path
import struct
import sys

m2_path = Path(sys.argv[1])
m3_path = Path(sys.argv[2])
objs_arg = Path(sys.argv[3]) if len(sys.argv) == 4 else None

for path in (m2_path, m3_path):
    if not path.is_file():
        raise SystemExit(f"error: file not found: {path}")

m2 = m2_path.read_bytes()
m3 = m3_path.read_bytes()

if len(m2) < 8 or len(m3) < 8:
    raise SystemExit("error: both files must be at least 8 bytes")

if (len(m2) - 8) % 24 != 0 or (len(m3) - 8) % 24 != 0:
    raise SystemExit("error: both files must fit the 8-byte-prelude plus 24-byte-record layout")

m2_records = [m2[8 + i:8 + i + 24] for i in range(0, len(m2) - 8, 24)]
m3_records = [m3[8 + i:8 + i + 24] for i in range(0, len(m3) - 8, 24)]

if len(m2_records) != len(m3_records):
    raise SystemExit("error: record counts differ; this analyzer expects matching counts")

def infer_objs_dir(connect_path: Path):
    # .../OPEN-R/MW/CONF/CONNECT.CFG -> .../OPEN-R/MW/OBJS
    try:
        return connect_path.parents[1] / "OBJS"
    except IndexError:
        return None

objs_dir = objs_arg or infer_objs_dir(m2_path)
obj_names = []
if objs_dir and objs_dir.is_dir():
    obj_names = sorted(p.name for p in objs_dir.glob("*.BIN"))

stable = []
versioned = []
for index, (a, b) in enumerate(zip(m2_records, m3_records)):
    entry = {
        "index": index,
        "m2": a,
        "m3": b,
        "m2_u32le": struct.unpack("<6I", a),
        "m3_u32le": struct.unpack("<6I", b),
    }
    if a == b:
        stable.append(entry)
    else:
        versioned.append(entry)

def spans(entries):
    if not entries:
        return []
    indexes = [entry["index"] for entry in entries]
    out = []
    start = prev = indexes[0]
    for idx in indexes[1:]:
        if idx == prev + 1:
            prev = idx
            continue
        out.append((start, prev))
        start = prev = idx
    out.append((start, prev))
    return out

print("Retail CONNECT.CFG aligned table analysis")
print(f"M2: {m2_path}")
print(f"M3: {m3_path}")
print(f"M2 prelude8: {m2[:8].hex()}")
print(f"M3 prelude8: {m3[:8].hex()}")
print(f"record-count: {len(m2_records)}")
print()

print(f"stable-records: {len(stable)}")
for start, end in spans(stable):
    print(f"- indexes {start}-{end} (count {end - start + 1})")
print()

print(f"versioned-records: {len(versioned)}")
for start, end in spans(versioned):
    print(f"- indexes {start}-{end} (count {end - start + 1})")
print()

if obj_names:
    print(f"mw-objects: {len(obj_names)}")
    print(f"stable-minus-mw-objects: {len(stable) - len(obj_names)}")
    print("mw-object-list:")
    for name in obj_names:
        print(f"- {name}")
    print()

print("record-labels:")
for entry in versioned:
    print(f"- record {entry['index']:02d}: versioned")
for entry in stable:
    print(f"- record {entry['index']:02d}: stable")

print()
print("sample-records:")
for bucket_name, bucket in (("versioned", versioned), ("stable", stable)):
    if not bucket:
        continue
    first = bucket[0]
    print(f"{bucket_name}-first: record {first['index']:02d}")
    print(f"  m2-hex24: {first['m2'].hex()}")
    print(f"  m3-hex24: {first['m3'].hex()}")
    print(f"  m2-u32le: {' '.join(str(v) for v in first['m2_u32le'])}")
    print(f"  m3-u32le: {' '.join(str(v) for v in first['m3_u32le'])}")
PY
