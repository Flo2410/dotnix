{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.user.app.waybar;

in
{
  options.user.app.waybar = {
    enable = mkEnableOption "waybar";
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = cfg.enable;
      settings.mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-center = [ "clock" ];
      };
    };
  };
}
