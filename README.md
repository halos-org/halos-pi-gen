# HaLOS - Hat Labs Operating System

HaLOS is a customized Raspberry Pi OS (Debian Trixie) distribution designed for marine electronics and IoT applications. It provides web-based system management through Cockpit and container app management via a custom app store interface.

This repository builds both HaLOS images and stock Raspberry Pi OS images with HALPI2 hardware customizations.

> **See also:** [halos-distro](https://github.com/hatlabs/halos-distro) - the main HaLOS development workspace with all related repositories.

## Features

- **Web-based Management**: Cockpit (port 9090) for system administration, terminal access, and service management
- **Container App Store**: Install and manage containerized applications through a web UI (port 80)
- **Marine Software Stack** (marine variants): Pre-configured Signal K, InfluxDB, and Grafana for boat data
- **HALPI2 Hardware Support**: Native drivers for Hat Labs HALPI2 hardware (CAN bus, RS-485, I2C sensors)
- **ARM64 Native**: Built for 64-bit Raspberry Pi (Pi 4, Pi 5, CM4, CM5)

## Image Variants

| Image | Hardware | Desktop | Marine Stack | Use Case |
|-------|----------|---------|--------------|----------|
| **Halos-Desktop-Marine-HALPI2-AP** | HALPI2 | Yes | Yes | **Default pre-installation image** with WiFi AP |
| **Halos-Desktop-Marine-HALPI2** | HALPI2 | Yes | Yes | Desktop marine system |
| **Halos-Marine-HALPI2** | HALPI2 | No | Yes | Headless marine system |
| **Halos-Desktop-HALPI2** | HALPI2 | Yes | No | Desktop HaLOS |
| **Halos-HALPI2** | HALPI2 | No | No | Headless HaLOS |

**Generic Raspberry Pi variants** (without HALPI2 drivers): Halos-Desktop-Marine-RPI, Halos-Marine-RPI, Halos-Desktop-RPI, Halos-RPI

## Downloading

Pre-built images are available on the [GitHub Releases page](https://github.com/hatlabs/halos-pi-gen/releases).

## Flashing

1. Download [Raspberry Pi Imager](https://www.raspberrypi.org/software/)
2. Connect your SSD/SD card via USB adapter
3. In Raspberry Pi Imager:
   - Choose "Use custom" and select the downloaded `.img.xz` file
   - Select your target drive
   - Add any customizations (hostname, SSH, WiFi) if you want to pre-configure e.g. WiFi access
4. Click "Write" and wait for completion

## First Boot

After flashing and booting:

1. **Connect to your network** via Ethernet (recommended) or configure WiFi
2. **Find the device IP** using your router's admin page or `ping halos.local`
3. **Access the web interfaces**:
   - **Cockpit**: `https://<ip>:9090` - System administration

### Default Credentials

- **Username**: `pi`
- **Password**: `raspberry`

> **Security Note**: Change the default password immediately after first login via Cockpit.

## Building from Source

### Requirements

- Docker installed and running
- ~20GB free disk space per image variant
- ARM64 host recommended (or use emulation)

### Build Commands

```bash
# Clone the repository
git clone https://github.com/hatlabs/halos-pi-gen.git
cd halos-pi-gen

# Build a specific variant
./run docker-build "Halos-Marine-HALPI2"

# Build all variants
./run docker-build-all

# Clean up Docker resources
./run docker-clean
```

### Local CI Testing

For testing the full CI workflow locally using [act](https://nektosact.com/):

```bash
# Install act (macOS)
brew install act

# Run PR workflow locally
act pull_request --container-architecture linux/arm64
```

### Build Output

Built images are placed in the `deploy/` directory:
- `<variant>-<date>.img.xz` - Compressed disk image
- `<variant>-<date>.img.xz.sha256` - Checksum file

## Project Structure

```
halos-pi-gen/
├── config.*                    # Image variant configurations
├── stage-halos-base/           # Cockpit + app store (all variants)
├── stage-halpi2-common/        # HALPI2 hardware drivers
├── stage-halos-marine/         # Marine software stack
├── .github/workflows/          # CI/CD pipelines
└── run                         # Build script
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

Pull requests trigger automatic image builds for testing.

## License

See [LICENSE](LICENSE) for details.

## Related Projects

- [halos-marine-containers](https://github.com/hatlabs/halos-marine-containers) - Marine app definitions
- [cockpit-apt](https://github.com/hatlabs/cockpit-apt) - Container app store UI
- [apt.hatlabs.fi](https://apt.hatlabs.fi) - Hat Labs APT repository
