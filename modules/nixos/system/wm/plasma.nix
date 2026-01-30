{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.wm.plasma;
in {
  options.system.wm.plasma = {
    enable = mkEnableOption "Plasma Desktop";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs.kdePackages; [
        plasma-thunderbolt
      ];

      plasma6.excludePackages = with pkgs.kdePackages; [
        discover
        plasma-browser-integration
        elisa
        konsole
        krunner
        baloo
        baloo-widgets
        kate
        gwenview
      ];
    };

    system.config = {
      stylix = {
        enable = true;
        theme = "catppuccin-mocha";
      };

      keyboard.enable = true;
    };

    # Configure plasma
    services = {
      xserver = {
        enable = true;
        excludePackages = [pkgs.xterm];
      };

      desktopManager.plasma6.enable = true;

      # Enable the KDE Plasma Desktop Environment.
      displayManager = {
        defaultSession = "plasma";

        sddm = {
          enable = true;
          theme = "breeze";
          wayland.enable = true;
        };
      };

      libinput = {
        mouse = {
          accelProfile = "flat";
          accelSpeed = "0";
        };
        touchpad.disableWhileTyping = true;
      };
    };
  };
}
