{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.wm.gnome;
in {
  options.system.wm.gnome = {
    enable = mkEnableOption "GNOME Desktop";
  };

  config = mkIf cfg.enable {
    system.config.stylix = {
      enable = true;
      theme = "catppuccin-mocha";
    };

    environment = {
      systemPackages = with pkgs; [
      ];

      gnome.excludePackages = with pkgs; [
        gnome-tour
        gnome-user-docs
      ];
    };

    # Configure plasma
    services = {
      xserver = {
        enable = true;
        xkb = {
          layout = "at";
          variant = "nodeadkeys";
          options = "caps:escape";
        };

        excludePackages = [pkgs.xterm];
      };

      gnome = {
        core-apps.enable = false;
        core-developer-tools.enable = false;
        games.enable = false;
      };

      displayManager = {
        defaultSession = "gnome";

        gdm.enable = true;
      };

      desktopManager.gnome.enable = true;

      libinput = {
        touchpad.disableWhileTyping = true;
      };
    };
  };
}
