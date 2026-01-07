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

      app = {
        rofi.enable = mkDefault true;
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

      input.keyboard = {
        numlockOnStartup = "on";
        options = ["caps:escape"];
      };

      hotkeys.commands."launch-rofi" = {
        name = "Launch Rofi";
        key = "Alt+Space";
        command = "rofi -show drun -modes drun,calc,window -replace";
      };

      shortcuts = {
        kwin = {
          "Expose" = "Meta+,";
          "Switch One Desktop to the Left" = "Meta+Ctrl+Left";
          "Switch One Desktop to the Right" = "Meta+Ctrl+Right";
          "Overview" = "Meta+W";
          "Window On All Desktops" = "Meta+Ctrl+A";
          "Close Window" = "Meta+Q";
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
          "Basic Settings"."Indexing-Enabled" = false;
          "General"."folders[$e]" = "$HOME/syncthing/";
          "General"."only basic indexing" = false;
        };
      };
    };
  };
}
