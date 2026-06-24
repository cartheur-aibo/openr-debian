# HelloWorld ERS-7 Test Stick

This feature builds a minimal programmable ERS-7 Memory Stick for first bring-up
on real hardware. It is for proving the OPEN-R base boots, Wi-Fi comes up, and
the wireless console works. It is not AIBO MIND 2.

## Do This

Open Wi-Fi with DHCP:

```bash
AIBO_HOSTNAME=AIBO \
ESSID=YOUR_WIFI_NAME \
WEPENABLE=0 \
USE_DHCP=1 \
./scripts/build-ers7-feature-stick.sh
```

WEP with DHCP:

```bash
AIBO_HOSTNAME=AIBO \
ESSID=YOUR_WIFI_NAME \
WEPENABLE=1 \
WEPKEY=YOUR_WEP_KEY \
USE_DHCP=1 \
./scripts/build-ers7-feature-stick.sh
```

Static IP:

```bash
AIBO_HOSTNAME=AIBO \
ESSID=YOUR_WIFI_NAME \
WEPENABLE=0 \
USE_DHCP=0 \
ETHER_IP=192.168.10.100 \
ETHER_NETMASK=255.255.255.0 \
IP_GATEWAY=192.168.10.1 \
DNS_SERVER_1=192.168.10.1 \
./scripts/build-ers7-feature-stick.sh
```

## Copy To Memory Stick

Copy these from:

- `features/hello-world/build/stick`

to the root of the mounted Memory Stick:

- `MEMSTICK.IND`
- `OPEN-R/`

Fastest way:

```bash
rsync -a --delete features/hello-world/build/stick/ /path/to/mounted-stick/
sync
```

Then:

1. Unmount or eject the stick cleanly.
2. Insert it into the ERS-7 while powered off.
3. Boot the robot.
4. Find its IP from DHCP, or use the static IP you configured.
5. Connect with `telnet AIBO_IP 59000`.

## What You Should See

If it worked, the main proof point is:

```text
!!! Hello World !!!
```

That comes from the sample's `DoStart()` handler in
[samples/common/HelloWorld/HelloWorld/HelloWorld.cc](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/samples/common/HelloWorld/HelloWorld/HelloWorld.cc:18).

## What This Stick Actually Boots

This stick boots:

- the ERS-7 `WCONSOLE` OPEN-R base
- `HELLO.BIN`
- `POWERMON.BIN`

That matters because the object names on the stick, not the host folder names,
control what the robot runs. The boot list lives in:

- [samples/common/HelloWorld/MS/OPEN-R/MW/CONF/OBJECT.CFG](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/samples/common/HelloWorld/MS/OPEN-R/MW/CONF/OBJECT.CFG)

`PowerMonitor` is there to handle pause and low-battery shutdown cleanly. Its
logic is in:

- [samples/common/PowerMonitor/PowerMonitor/PowerMonitor.cc](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/samples/common/PowerMonitor/PowerMonitor/PowerMonitor.cc:22)

## Useful Knowledge

- The builder is reusable. By default it derives the feature output folder from
  the sample name, so `HelloWorld` maps to `features/hello-world/`.
- Generated outputs stay under `features/hello-world/build/`, not in `samples/`.
- The SDK `WCONSOLE` base is small, about `1.1 MiB` before adding the sample
  payload, so this fits easily on an 8 MB Memory Stick.
- Wi-Fi here follows the old Sony constraints in
  [features/ers7-wifi/README.md](/home/cartheur/ame/aiventure/aiventure-github/cartheur-aibo/openr-debian/features/ers7-wifi/README.md):
  open or WEP-era networking, not WPA/WPA2/WPA3.
