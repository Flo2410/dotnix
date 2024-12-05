{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.hardware.filesystem;
in {
  options.system.hardware.filesystem = {
    enable = mkEnableOption "Enable extra filesystem support";
    autoMounts = mkOption {
      type = types.listOf (types.enum [
        "/mnt/florian"
      ]);
      default = [];
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.cifs-utils];
    boot.supportedFilesystems = ["cifs"];

    # //10.56.20.11/florian /mnt/florian cifs defaults,vers=3.0,rw,credentials=/home/florian/.smb-creds,iocharset=utf8,uid=1000,gid=1000,noauto,x-systemd.automount,x-systemd.idle-timeout=30,x-systemd.mount-timeout=10 0 0
    fileSystems."/mnt/florian" = mkIf (builtins.elem "/mnt/florian" cfg.autoMounts) {
      device = "//10.56.20.11/florian";
      fsType = "cifs";
      options = [
        "defaults"
        "vers=3.0"
        "rw"
        "credentials=/home/florian/.smb-creds"
        "iocharset=utf8"
        "uid=1000"
        "gid=100"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=30"
        "x-systemd.mount-timeout=10"
      ];
    };
  };
}
