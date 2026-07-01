#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  scripts/rewrite-sttlog-rows.sh <source-sttlog> <target-sttlog> <row-key> [<row-key> ...]

Rewrite selected STTLOG rows in <target-sttlog> using the matching rows from
<source-sttlog>, preserving the rest of the target file unchanged.

Example:
  scripts/rewrite-sttlog-rows.sh \
    opt/AIBO7M2/OPEN-R/APP/DATA/P/STTLOG \
    features/mind2-behavior-research/build/specimen/OPEN-R/APP/DATA/P/STTLOG \
    1000 0400 0300 1200 0046
EOF
}

if [ "$#" -lt 3 ] || [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit $([ "$#" -ge 3 ] && [ "${1:-}" != "-h" ] && [ "${1:-}" != "--help" ] && echo 0 || echo 1)
fi

python3 - "$@" <<'PY'
from pathlib import Path
import sys

source_path = Path(sys.argv[1])
target_path = Path(sys.argv[2])
keys = set(sys.argv[3:])

for path in (source_path, target_path):
    if not path.is_file():
        raise SystemExit(f"error: file not found: {path}")

source_lines = source_path.read_text().splitlines()
target_lines = target_path.read_text().splitlines()

source_map = {}
for line in source_lines:
    parts = line.split()
    if len(parts) == 7 and len(parts[0]) == 4:
        source_map[parts[0]] = line

missing = sorted(key for key in keys if key not in source_map)
if missing:
    raise SystemExit(f"error: source missing requested rows: {', '.join(missing)}")

rewritten = []
replaced = set()
for line in target_lines:
    parts = line.split()
    if len(parts) == 7 and len(parts[0]) == 4 and parts[0] in keys:
        rewritten.append(source_map[parts[0]])
        replaced.add(parts[0])
    else:
        rewritten.append(line)

missing_in_target = sorted(keys - replaced)
if missing_in_target:
    raise SystemExit(f"error: target missing requested rows: {', '.join(missing_in_target)}")

target_path.write_text("\n".join(rewritten) + "\n")
print(f"rewrote {len(replaced)} rows in {target_path}")
for key in sorted(replaced):
    print(f"- {key}")
PY
