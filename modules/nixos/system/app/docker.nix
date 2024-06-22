{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.system.app.docker;
in
{
  options.system.app.docker = {
    enable = mkEnableOption "Docker";
    storageDriver = mkOption {
      type = types.nullOr (types.enum [
        "aufs"
        "btrfs"
        "devicemapper"
        "overlay"
        "overlay2"
        "zfs"
      ]);
      default = "overlay2";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      storageDriver = cfg.storageDriver;
      autoPrune.enable = true;
    };
  };
}
