{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.system.app.thunar;
in {
  options.system.app.thunar = {
    enable = mkEnableOption "Thunar";
  };

  config = mkIf cfg.enable {
    services = {
      gvfs.enable = mkDefault true; # Thunar: Mount, trash, and other functionalities
      tumbler.enable = mkDefault true; # Thumbnail support for images
    };

    programs = {
      xfconf.enable = mkDefault true;

      thunar = {
        enable = mkForce true;
        plugins = with pkgs.xfce; [
          thunar-archive-plugin
          thunar-volman
        ];
      };
    };
  };
}
