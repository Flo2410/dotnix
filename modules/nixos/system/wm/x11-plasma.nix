{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.system.wm.x11-plasma;
in
{

  options.system.wm.x11-plasma = {
    enable = mkEnableOption "X11 Plasma Desktop";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      plasma5Packages.plasma-thunderbolt
    ];

    # Configure X11
    services = {
      xserver = {
        enable = true;
        xkb = {
          layout = "at";
          variant = "nodeadkeys";
        };
      };

      desktopManager.plasma6.enable = true;

      # Enable the KDE Plasma Desktop Environment.
      displayManager = {
        defaultSession = "plasmax11";

        sddm = {
          enable = true;
          theme = "breeze";
        };
      };

      libinput = {
        touchpad.disableWhileTyping = true;
      };
    };
  };
}
