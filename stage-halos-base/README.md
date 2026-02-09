# stage-halos-base

This stage installs the core HaLOS components that are included in all HaLOS variants.

## What it Does

Installs the `halos` metapackage from apt.hatlabs.fi, which provides:

- **Docker** (docker.io, docker-compose, docker-cli)
- **Cockpit** web-based system administration (port 9090)
  - cockpit-networkmanager (network management)
  - cockpit-storaged (storage management)
  - cockpit-apt (package management)
  - cockpit-dockermanager (Docker container management)
  - cockpit-branding-halos (HaLOS branding)

## Structure

```
stage-halos-base/
├── 00-install-halos/
│   └── 00-packages      # halos metapackage
├── prerun.sh
└── README.md
```

## Services Enabled

After this stage, the following services are enabled:
- **docker.service** - Docker daemon
- **cockpit.socket** - Cockpit web interface (port 9090)

## Dependencies

- **stage-hatlabs-common** must run before this stage to add the apt.hatlabs.fi repository

## Applies To

This stage is included in all HaLOS image variants.
