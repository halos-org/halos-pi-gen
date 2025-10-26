# HaLOS Image Builder

Builds HaLOS (Hat Labs Operating System) images using pi-gen for HALPI2 and generic Raspberry Pi.

## Git Workflow Policy

**IMPORTANT:** Always ask before committing, pushing, tagging, or running destructive git operations.

## Building Images

```bash
# Build specific variant
./run docker-build "HaLOS-Marine-HALPI2"

# Build all enabled variants
./run docker-build-all

# Clean up
./run docker-clean
```

## Image Variants

Defined by `config.*` files. Naming: `HaLOS[-Lite]-[Marine-]<HALPI2|RPI>`

- **Lite**: Headless (no desktop)
- **Marine**: Pre-configured Signal K, InfluxDB, Grafana
- **HALPI2**: HALPI2 hardware support
- **RPI**: Generic Raspberry Pi

## Stage System

Pi-gen uses stages (run in order). Custom HaLOS stages:

- **stage-halos-base**: Cockpit + Runtipi (all variants)
- **stage-halpi2-common**: HALPI2 hardware drivers, firmware, interfaces
- **stage-halos-marine**: Marine stack (Signal K, InfluxDB, Grafana)
- **stage-halpi2-rpi**: HALPI2 desktop customizations

## Adding Stage Tasks

Create numbered directory: `stage-*/##-task-name/`

- `00-packages`: Packages to install (one per line)
- `01-run-chroot.sh`: Script runs inside chroot
- `files/`: Config files to copy

## Creating New Variants

1. Create `config.variant-name` with stage list
2. Set `IMG_NAME`, `STAGE_LIST`, `COMPRESSION_LEVEL`
3. Add to `.github/workflows/pull_request.yml` matrix
4. Test: `./run docker-build "Variant-Name"`
