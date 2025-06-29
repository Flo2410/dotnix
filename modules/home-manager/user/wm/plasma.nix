{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.user.wm.plasma;
in {
  options.user.wm.plasma = {
    enable = mkEnableOption "Plasma Desktop";
  };

  config = mkIf cfg.enable {
    user = {
      config = {
        stylix = {
          enable = mkDefault true;
          theme = "catppuccin-mocha";
          wallpaper = ../../../../assets/wallpapers/nixos-wallpaper.png;
        };
      };
    };

    programs.plasma = {
      enable = true;

      workspace = {
        # lookAndFeel = "org.kde.breezedark.desktop";
        # cursor.theme = "Breeze";
        # iconTheme = "breeze-dark";
        # wallpaper = ../../../../assets/wallpapers/Abstract_1-hue_logo.jpg;
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
