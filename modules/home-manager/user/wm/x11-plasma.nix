{ lib, pkgs, config, inputs, ... }:

with lib;
let
  cfg = config.user.wm.x11-plasma;
in
{

  options.user.wm.x11-plasma = {
    enable = mkEnableOption "X11 Plasma Desktop";
  };

  config = mkIf cfg.enable {
    programs.plasma = {
      enable = true;

      workspace = {
        lookAndFeel = "org.kde.breezedark.desktop";
        cursorTheme = "Breeze";
        iconTheme = "breeze-dark";
        wallpaper = ../../../../wallpapers/framework/Abstract_1-hue_logo.jpg;
      };
    };

  };
}
