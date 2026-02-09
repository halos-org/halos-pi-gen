# Stage: halos-desktop

Desktop environment customizations for HaLOS desktop variants.

## Tasks

### 00-configure-desktop

Configures desktop environment with HaLOS-specific customizations:

- Copies Cockpit and Homarr desktop launchers to user's Desktop
- Adds launchers to the Wayfire panel (top bar) for quick access

The .desktop files are provided by packages (halos-cockpit-branding, halos-homarr-branding)
and use `http://*.localhost/` URLs which Traefik redirects to the proper `https://*.local` addresses.

**Panel Configuration Behavior:**
- If `wf-panel-pi.ini` already exists (user has customized panel), appends Cockpit and Homarr to the end of existing launchers
- If `wf-panel-pi.ini` doesn't exist, installs default configuration with standard launchers plus Cockpit and Homarr
