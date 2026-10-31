# Waveshare RS485 CAN HAT on HALPI2

This document records the HALPI2 image configuration for the Waveshare RS485
CAN HAT with MCP2515, SN65HVD230, and SP3485.

## Hardware mapping

The HAT uses the following Raspberry Pi signals:

| Function | GPIO/interface |
| --- | --- |
| CAN SPI chip select | SPI0 CE0 (`spi0.0`) |
| CAN interrupt | GPIO25 |
| CAN oscillator | 12 MHz (`12,000` marking on the crystal) |
| RS485 UART TX/RX | GPIO14/GPIO15, primary UART |
| RS485 direction | Automatic on the HAT; RSE GPIO4 is not required for the default mode |

HALPI2’s existing CAN controller remains on `spi0.1` as `can0`. The Waveshare
controller is added on `spi0.0` and is expected to appear as `can1`. The
existing HALPI2 RS485 interface on `/dev/ttyAMA4` is not replaced.

## Image configuration

The overlay is installed by:

`stage-halpi2-common/05-setup-can/files/config.txt.part`

```ini
dtoverlay=spi0-2cs,cs1_pin=6
dtoverlay=mcp251xfd,spi0-1,interrupt=26,oscillator=40000000
dtoverlay=mcp2515,spi0-0,oscillator=12000000,interrupt=25,speed=2000000
```

The existing `80-can.network` configuration matches `can*`, so both `can0`
and `can1` receive the default 250 kbit/s CAN bitrate and automatic restart
configuration. NMEA 2000 uses 250 kbit/s; other CAN devices may require a
different bitrate.

The image must be built on the development machine. Do not compile or build
on HALPI2.

## Verification after reboot

On HALPI2, check that both controllers are present:

```sh
ls -l /dev/spidev*
ip -details link show can0
ip -details link show can1
sudo dmesg | grep -iE 'mcp251|can|spi'
```

Bring the new interface up if the network service has not done so:

```sh
sudo ip link set can1 up type can bitrate 250000 restart-ms 100
ip -details link show can1
```

For a passive bus check, use:

```sh
candump -L can1
```

Do not transmit test frames onto a live vessel network without confirming the
CAN bitrate, wiring, termination, and test plan first.

## RS485 verification

The primary UART is exposed as `/dev/ttyAMA0` on the current HALPI2 image. The
existing HALPI2 RS485 provider uses `/dev/ttyAMA4`; keep these two providers
separate in Signal K.

Before adding a Signal K provider for the Waveshare port, verify the device
and serial parameters with the connected instrument or a safe RS485 loopback:

```sh
ls -l /dev/ttyAMA0 /dev/ttyAMA4
sudo stty -F /dev/ttyAMA0 4800 cs8 -cstopb -parenb -ixon -ixoff
```

The baud rate, parity, and protocol must match the connected device. The HAT
normally performs automatic RS485 transmit/receive direction control.

## Signal K integration

The base image keeps the existing HALPI2 NMEA 2000 provider on `can0`. After
`can1` has been confirmed electrically, Signal K can be configured to use
`can1` for a Waveshare-connected NMEA 2000 network by changing the provider’s
CAN interface from `can0` to `can1`.

Do not enable a second provider on the same physical bus. If both CAN
controllers are connected to separate networks, use separate provider IDs and
confirm that each network has only one required termination arrangement.

## Troubleshooting

- If only `can0` appears, inspect the MCP2515 line in `/boot/firmware/config.txt`
  and reboot. The HAT must be seated correctly and SPI0 CE0 must not be used
  by another device.
- If the kernel reports an MCP2515 clock or bit-timing error, verify the
  crystal marking. This integration assumes 12 MHz, not 8 MHz.
- `ERROR-PASSIVE` or rising RX error counters usually indicate missing CAN
  termination, incorrect bitrate, reversed CAN-H/CAN-L, or no active bus
  partner. It is not by itself proof of a software defect.
- If `/dev/ttyAMA0` is unavailable, check that UART0 is enabled and that the
  serial console is not attached to the HAT’s GPIO14/GPIO15 pins.
