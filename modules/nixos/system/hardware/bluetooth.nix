{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.hardware.bluetooth;
in {
  options.system.hardware.bluetooth = {
    enable = mkEnableOption "Bluetooth";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

    # https://github.com/NixOS/nixpkgs/issues/170573
    systemd.services."bluetooth".serviceConfig = {
      StateDirectory = ""; # <<< minimal solution, applied in override.conf

      # Seems unnecessary, but useful to keep in mind if bluetooth
      # defaults get locked down even more:
      # ReadWritePaths="/persist/var/lib/bluetooth/";
    };

    # services.blueman.enable = true;
  };
}
