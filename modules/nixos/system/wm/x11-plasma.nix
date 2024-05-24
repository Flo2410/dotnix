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
    services.xserver = {
      enable = true;
      layout = "at";
      xkbVariant = "nodeadkeys";

      # Enable the KDE Plasma Desktop Environment.
      displayManager.sddm = {
        enable = true;
        theme = "breeze";
      };

      desktopManager.plasma5.enable = true;

      libinput = {
        touchpad.disableWhileTyping = true;
      };
    };
  };
}
