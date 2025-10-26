# Stage: halos-desktop

Desktop environment customizations for HaLOS desktop variants.

## Tasks

### 00-configure-desktop

Configures desktop environment with HaLOS-specific customizations:

- Creates desktop launcher shortcuts for Runtipi web UI (http://halpi2.local/)
- Creates desktop launcher shortcuts for Cockpit web UI (https://halpi2.local:9090/)
- Adds launchers to the Wayfire panel (top bar) for quick access

The launchers open the respective web interfaces in the default browser.

**Panel Configuration Behavior:**
- If `wf-panel-pi.ini` already exists (user has customized panel), appends Cockpit and Runtipi to the end of existing launchers
- If `wf-panel-pi.ini` doesn't exist, installs default configuration with standard launchers plus Cockpit and Runtipi
