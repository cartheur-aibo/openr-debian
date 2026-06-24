#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
usage: build-ers7-feature-stick.sh [/path/to/output-dir]

Build a scratch ERS-7 programmable Memory Stick tree sized for an 8 MB stick,
using the SDK's WCONSOLE base plus the HelloWorld + PowerMonitor test payload.
By default, build outputs live under features/<feature-slug>/.

Environment variables:
  OPENRSDK_ROOT   SDK root. Defaults to ./sdk/local/OPEN_R_SDK
  SAMPLE_DIR      Sample root. Default: ./samples/common/HelloWorld
  FEATURE_SLUG    Feature output folder name. Default: derived from SAMPLE_DIR
  PAYLOAD_MODE    base-only, hello-only, or hello-plus-powermon. Default: hello-plus-powermon
  SYSTEM_SOURCE   sdk, runtime-mind2, or runtime-mind3. Default: sdk
  STICK_FLAVOR    BASIC, WCONSOLE, or WLAN. Default: WCONSOLE
  MEMPROT         memprot or nomemprot. Default: memprot
  AIBO_HOSTNAME   Default: AIBO
  ESSID           Default: AIBONET
  WEPENABLE       0 or 1. Default: 0
  WEPKEY          Optional. Used when WEPENABLE=1
  APMODE          Default: 1
  CHANNEL         Default: 3
  USE_DHCP        0 or 1. Default: 1
  ETHER_IP        Required when USE_DHCP=0
  ETHER_NETMASK   Required when USE_DHCP=0
  IP_GATEWAY      Required when USE_DHCP=0
  DNS_SERVER_1    Optional
  DNS_DEFDNAME    Optional
EOF
}

if [ "$#" -gt 1 ]; then
  usage
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OPENRSDK_ROOT="${OPENRSDK_ROOT:-$ROOT_DIR/sdk/local/OPEN_R_SDK}"
SAMPLE_DIR="${SAMPLE_DIR:-$ROOT_DIR/samples/common/HelloWorld}"
PAYLOAD_MODE="${PAYLOAD_MODE:-hello-plus-powermon}"
SYSTEM_SOURCE="${SYSTEM_SOURCE:-sdk}"
STICK_FLAVOR="${STICK_FLAVOR:-WCONSOLE}"
MEMPROT="${MEMPROT:-memprot}"
AIBO_HOSTNAME="${AIBO_HOSTNAME:-AIBO}"
ESSID="${ESSID:-AIBONET}"
WEPENABLE="${WEPENABLE:-0}"
WEPKEY="${WEPKEY:-}"
APMODE="${APMODE:-1}"
CHANNEL="${CHANNEL:-3}"
USE_DHCP="${USE_DHCP:-1}"
ETHER_IP="${ETHER_IP:-}"
ETHER_NETMASK="${ETHER_NETMASK:-}"
IP_GATEWAY="${IP_GATEWAY:-}"
DNS_SERVER_1="${DNS_SERVER_1:-}"
DNS_DEFDNAME="${DNS_DEFDNAME:-}"

slugify() {
  printf '%s' "$1" \
    | sed -E 's/([a-z0-9])([A-Z])/\1-\2/g' \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//'
}

SAMPLE_BASENAME="$(basename "$SAMPLE_DIR")"
FEATURE_SLUG="${FEATURE_SLUG:-$(slugify "$SAMPLE_BASENAME")}"
FEATURE_DIR="$ROOT_DIR/features/$FEATURE_SLUG"
BUILD_ROOT="$FEATURE_DIR/build"
OUTPUT_DIR="${1:-$BUILD_ROOT/stick}"

BASE_DIR="$OPENRSDK_ROOT/OPEN_R/MS_ERS7/$STICK_FLAVOR/$MEMPROT/OPEN-R"
RUNTIME_MIND2_DIR="$ROOT_DIR/opt/AIBO7M2/OPEN-R"
RUNTIME_MIND3_DIR="$ROOT_DIR/opt/AIBO7M3/OPEN-R"
POWERMON_SAMPLE_DIR="$ROOT_DIR/samples/common/PowerMonitor"
WORK_COMMON_DIR="$BUILD_ROOT/work/samples/common"
SAMPLE_WORK_DIR="$WORK_COMMON_DIR/$SAMPLE_BASENAME"
POWERMON_WORK_DIR="$WORK_COMMON_DIR/PowerMonitor"
PAYLOAD_STAGE_DIR="$BUILD_ROOT/payload"
COPY_NOTE_FILE="$BUILD_ROOT/COPY_TO_MS.txt"
SAMPLE_COMPONENT_DIR="$SAMPLE_WORK_DIR/$SAMPLE_BASENAME"
POWERMON_COMPONENT_DIR="$POWERMON_WORK_DIR/PowerMonitor"

require_file() {
  if [ ! -e "$1" ]; then
    echo "error: missing required path: $1" >&2
    exit 1
  fi
}

require_file "$BASE_DIR"
require_file "$SAMPLE_DIR/Makefile"
require_file "$POWERMON_SAMPLE_DIR"

case "$PAYLOAD_MODE" in
  base-only|hello-only|hello-plus-powermon) ;;
  *)
    echo "error: PAYLOAD_MODE must be base-only, hello-only, or hello-plus-powermon" >&2
    exit 1
    ;;
esac

case "$SYSTEM_SOURCE" in
  sdk)
    RUNTIME_OPENR_DIR=""
    ;;
  runtime-mind2)
    RUNTIME_OPENR_DIR="$RUNTIME_MIND2_DIR"
    require_file "$RUNTIME_OPENR_DIR/SYSTEM"
    ;;
  runtime-mind3)
    RUNTIME_OPENR_DIR="$RUNTIME_MIND3_DIR"
    require_file "$RUNTIME_OPENR_DIR/SYSTEM"
    ;;
  *)
    echo "error: SYSTEM_SOURCE must be sdk, runtime-mind2, or runtime-mind3" >&2
    exit 1
    ;;
esac

case "$STICK_FLAVOR" in
  BASIC|WCONSOLE|WLAN) ;;
  *)
    echo "error: STICK_FLAVOR must be BASIC, WCONSOLE, or WLAN" >&2
    exit 1
    ;;
esac

case "$MEMPROT" in
  memprot|nomemprot) ;;
  *)
    echo "error: MEMPROT must be memprot or nomemprot" >&2
    exit 1
    ;;
esac

case "$WEPENABLE" in
  0|1) ;;
  *)
    echo "error: WEPENABLE must be 0 or 1" >&2
    exit 1
    ;;
esac

case "$USE_DHCP" in
  0|1) ;;
  *)
    echo "error: USE_DHCP must be 0 or 1" >&2
    exit 1
    ;;
esac

if [ "${#AIBO_HOSTNAME}" -gt 8 ]; then
  echo "error: AIBO_HOSTNAME must be 8 characters or fewer" >&2
  exit 1
fi

if [ "$WEPENABLE" = "1" ] && [ -z "$WEPKEY" ]; then
  echo "error: WEPKEY is required when WEPENABLE=1" >&2
  exit 1
fi

if [ "$USE_DHCP" = "0" ]; then
  if [ -z "$ETHER_IP" ] || [ -z "$ETHER_NETMASK" ] || [ -z "$IP_GATEWAY" ]; then
    echo "error: ETHER_IP, ETHER_NETMASK, and IP_GATEWAY are required when USE_DHCP=0" >&2
    exit 1
  fi
fi

rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"
rm -rf "$WORK_COMMON_DIR" "$PAYLOAD_STAGE_DIR"
mkdir -p "$WORK_COMMON_DIR" "$PAYLOAD_STAGE_DIR/OPEN-R/MW/OBJS"

if [ "$PAYLOAD_MODE" != "base-only" ]; then
  cp -a "$SAMPLE_DIR" "$SAMPLE_WORK_DIR"
fi
if [ "$PAYLOAD_MODE" = "hello-plus-powermon" ]; then
  cp -a "$POWERMON_SAMPLE_DIR" "$POWERMON_WORK_DIR"
fi

cp -a "$BASE_DIR" "$OUTPUT_DIR/OPEN-R"
chmod -R u+w "$OUTPUT_DIR/OPEN-R"
: > "$OUTPUT_DIR/MEMSTICK.IND"

if [ "$SYSTEM_SOURCE" != "sdk" ]; then
  rm -rf "$OUTPUT_DIR/OPEN-R/SYSTEM"
  cp -a "$RUNTIME_OPENR_DIR/SYSTEM" "$OUTPUT_DIR/OPEN-R/SYSTEM"
  chmod -R u+w "$OUTPUT_DIR/OPEN-R/SYSTEM"

  for root_item in APERINIT.GZ APERIOS.GZ BOOTPARA STIKSAFE.BIN; do
    if [ -e "$RUNTIME_OPENR_DIR/$root_item" ]; then
      cp -a "$RUNTIME_OPENR_DIR/$root_item" "$OUTPUT_DIR/OPEN-R/$root_item"
    fi
  done

  rm -f "$OUTPUT_DIR/OPEN-R/VERSION.txt"
fi

if [ "$STICK_FLAVOR" != "BASIC" ] || [ -e "$OUTPUT_DIR/OPEN-R/SYSTEM/CONF/WLANCONF.TXT" ]; then
  cat > "$OUTPUT_DIR/OPEN-R/SYSTEM/CONF/WLANCONF.TXT" <<EOF
HOSTNAME=$AIBO_HOSTNAME
EOF

  if [ "$USE_DHCP" = "0" ]; then
    cat >> "$OUTPUT_DIR/OPEN-R/SYSTEM/CONF/WLANCONF.TXT" <<EOF
ETHER_IP=$ETHER_IP
ETHER_NETMASK=$ETHER_NETMASK
IP_GATEWAY=$IP_GATEWAY
EOF
  fi

  cat >> "$OUTPUT_DIR/OPEN-R/SYSTEM/CONF/WLANCONF.TXT" <<EOF
ESSID=$ESSID
WEPENABLE=$WEPENABLE
EOF

  if [ "$WEPENABLE" = "1" ]; then
    cat >> "$OUTPUT_DIR/OPEN-R/SYSTEM/CONF/WLANCONF.TXT" <<EOF
WEPKEY=$WEPKEY
EOF
  fi

  cat >> "$OUTPUT_DIR/OPEN-R/SYSTEM/CONF/WLANCONF.TXT" <<EOF
APMODE=$APMODE
CHANNEL=$CHANNEL
EOF

  if [ -n "$DNS_SERVER_1" ]; then
    echo "DNS_SERVER_1=$DNS_SERVER_1" >> "$OUTPUT_DIR/OPEN-R/SYSTEM/CONF/WLANCONF.TXT"
  fi

  if [ -n "$DNS_DEFDNAME" ]; then
    echo "DNS_DEFDNAME=$DNS_DEFDNAME" >> "$OUTPUT_DIR/OPEN-R/SYSTEM/CONF/WLANCONF.TXT"
  fi

  if [ "$USE_DHCP" = "1" ]; then
    echo "USE_DHCP=1" >> "$OUTPUT_DIR/OPEN-R/SYSTEM/CONF/WLANCONF.TXT"
  fi
fi

if [ "$PAYLOAD_MODE" = "hello-plus-powermon" ]; then
  make -C "$SAMPLE_WORK_DIR" install \
    OPENRSDK_ROOT="$OPENRSDK_ROOT" \
    INSTALLDIR="$PAYLOAD_STAGE_DIR"

  cp -a "$PAYLOAD_STAGE_DIR/OPEN-R/MW/OBJS/HELLO.BIN" "$OUTPUT_DIR/OPEN-R/MW/OBJS/"
  cp -a "$PAYLOAD_STAGE_DIR/OPEN-R/MW/OBJS/POWERMON.BIN" "$OUTPUT_DIR/OPEN-R/MW/OBJS/"
  cp -a "$SAMPLE_WORK_DIR/MS/OPEN-R/MW/CONF/OBJECT.CFG" "$OUTPUT_DIR/OPEN-R/MW/CONF/OBJECT.CFG"
elif [ "$PAYLOAD_MODE" = "hello-only" ]; then
  make -C "$SAMPLE_COMPONENT_DIR" install \
    OPENRSDK_ROOT="$OPENRSDK_ROOT" \
    INSTALLDIR="$PAYLOAD_STAGE_DIR"

  cp -a "$PAYLOAD_STAGE_DIR/OPEN-R/MW/OBJS/HELLO.BIN" "$OUTPUT_DIR/OPEN-R/MW/OBJS/"
  cat > "$OUTPUT_DIR/OPEN-R/MW/CONF/OBJECT.CFG" <<'EOF'
/MS/OPEN-R/MW/OBJS/HELLO.BIN
EOF
else
  : > "$OUTPUT_DIR/OPEN-R/MW/CONF/OBJECT.CFG"
fi

cat > "$COPY_NOTE_FILE" <<EOF
ERS-7 Memory Stick copy notes

Feature slug: $FEATURE_SLUG
Sample: $SAMPLE_BASENAME
Build root: $BUILD_ROOT
Stick staging dir: $OUTPUT_DIR
Payload mode: $PAYLOAD_MODE
System source: $SYSTEM_SOURCE

Copy these items to the root of the mounted Memory Stick:

- MEMSTICK.IND
- OPEN-R/

Example:

  rsync -a --delete "$OUTPUT_DIR"/ /path/to/mounted-stick/
  sync

After copying:

1. Eject/unmount the stick cleanly.
2. Insert it into the ERS-7 while powered off.
3. Boot the robot.
4. If Wi-Fi succeeds, connect to the wireless console:
   telnet AIBO_IP 59000
EOF

SIZE_BYTES="$(du -sb "$OUTPUT_DIR" | awk '{print $1}')"
SIZE_MIB="$(awk -v bytes="$SIZE_BYTES" 'BEGIN { printf "%.2f", bytes / (1024 * 1024) }')"

echo "Built ERS-7 test stick at: $OUTPUT_DIR"
echo "Feature slug: $FEATURE_SLUG"
echo "Feature build root: $BUILD_ROOT"
echo "System source: $SYSTEM_SOURCE"
echo "Flavor: $STICK_FLAVOR/$MEMPROT"
echo "Wi-Fi: ESSID=$ESSID APMODE=$APMODE DHCP=$USE_DHCP WEP=$WEPENABLE"
echo "Payload mode: $PAYLOAD_MODE"
if [ "$PAYLOAD_MODE" = "hello-plus-powermon" ]; then
  echo "Payload: $SAMPLE_BASENAME + PowerMonitor"
elif [ "$PAYLOAD_MODE" = "hello-only" ]; then
  echo "Payload: $SAMPLE_BASENAME only"
else
  echo "Payload: base system only"
fi
echo "Size: ${SIZE_MIB} MiB (${SIZE_BYTES} bytes)"
echo "Copy note: $COPY_NOTE_FILE"
echo "Files to copy to the stick root:"
echo "  MEMSTICK.IND"
echo "  OPEN-R/"
