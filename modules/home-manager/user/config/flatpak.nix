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
    home.file.".local/share/flatpak/overrides/global".text = ''
      [Context]
      filesystems=xdg-config/gtk-4.0:ro;xdg-config/gtk-3.0:ro;/nix/store:ro;/run/current-system/sw/share/X11/fonts:ro;~/.local/share/fonts:ro;~/.icons:ro;
    '';
  };
}
