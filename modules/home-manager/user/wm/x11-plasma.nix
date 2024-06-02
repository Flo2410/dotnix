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
      shortcuts = {
        kwin = {
          "Expose" = "Meta+,";
          "Switch One Desktop to the Left" = "Meta+Ctrl+Left";
          "Switch One Desktop to the Right" = "Meta+Ctrl+Right";
          "Overview" = "Meta+W";
          "Window On All Desktops" = "Meta+Ctrl+A";
        };
      };

      configFile = {
        kwinrc = {
          "Windows".RollOverDesktops = true;
          "TabBox".LayoutName = "compact";
          "TabBoxAlternative".LayoutName = "compact";
          "ModifierOnlyShortcuts".Meta = "";
        };

        baloofilerc = {
          "Basic Settings"."Indexing-Enabled" = true;
          "General"."folders[$e]" = "$HOME/syncthing/";
          "General"."only basic indexing" = false;
        };
      };
    };
  };
}
