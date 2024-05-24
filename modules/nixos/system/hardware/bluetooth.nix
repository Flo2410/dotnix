{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.system.hardware.bluetooth;
in
{
  options.system.hardware.bluetooth = {
    enable = mkEnableOption "Bluetooth";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

    # services.blueman.enable = true;
  };
}
