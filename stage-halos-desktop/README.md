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

### 01-set-autologin

Configures lightdm for autologin to the default user.

### 02-install-halpi2-desktop

On HALPI2 builds (detected via `dpkg -l halos-halpi2`), installs `halos-halpi2-desktop`, which transitively pulls in `halos-halpi-desktop-branding` as the resolved provider of the virtual `halos-desktop-wallpaper`. Generic desktop builds skip this and keep the alphabetically-resolved generic provider `halos-desktop-branding`.

Mirrors the `dpkg -l` check pattern in `stage-halos-marine/02-install-combination-metapackage/`.
