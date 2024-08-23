{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.user.app.hyprlock;

in
{
  options.user.app.hyprlock = {
    enable = mkEnableOption "Hyprlock";
    wallpaper = mkOption {
      type = types.path;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    programs.hyprlock = {
      enable = cfg.enable;

      settings = {
        general = {
          disable_loading_bar = mkDefault true;
          hide_cursor = mkDefault false;
          no_fade_in = mkDefault false;
        };

        background = [{
          monitor = "";
          path = "${cfg.wallpaper}";
        }];
      };
    };
  };
}
