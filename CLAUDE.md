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

## Stage System

Pi-gen uses stages (run in order). Custom HaLOS stages:

- **stage-halos-base**: Cockpit + Runtipi (all variants)
- **stage-halpi2-common**: HALPI2 hardware drivers, firmware, interfaces
- **stage-halos-marine**: Marine stack (Signal K, InfluxDB, Grafana)
