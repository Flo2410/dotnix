{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.user.config.flatpak;
in {
  options.user.config.flatpak = {
    enable = mkEnableOption "Flatpak";
  };

  config = mkIf cfg.enable {
    services.flatpak.overrides = {
      global = {
        # Force Wayland by default
        Context.sockets = ["wayland" "!x11" "!fallback-x11"];

        Context.filesystems = [
          "xdg-config/gtk-4.0:ro"
          "xdg-config/gtk-3.0:ro"
          "/nix/store:ro"
          "/run/current-system/sw/share/X11/fonts:ro"
          "~/.local/share/fonts:ro"
          "~/.icons:ro"
        ];

        Environment = {
          # Fix un-themed cursor in some Wayland apps
          XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";

          # Force correct theme for some GTK apps
          GTK_THEME = "adw-gtk3";
        };
      };
    };
  };
}
