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
        "/mnt/paperless_consumption"
      ]);
      default = [];
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.cifs-utils];
    boot.supportedFilesystems = ["cifs"];

    # //10.56.20.11/florian /mnt/florian cifs defaults,vers=3.0,rw,credentials=/home/florian/.smb-creds,iocharset=utf8,uid=1000,gid=1000,noauto,x-systemd.automount,x-systemd.idle-timeout=30,x-systemd.mount-timeout=10 0 0
    fileSystems = let
      mkMount = {
        local_path,
        remote_path ? local_path,
      }:
        mkIf (builtins.elem "/mnt/${local_path}" cfg.autoMounts) {
          device = "//10.56.20.11/${remote_path}";
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
            "x-systemd.mount-timeout=5"
            "soft"
            "nofail"
          ];
        };
    in {
      "/mnt/florian" = mkMount {
        local_path = "florian";
      };

      "/mnt/paperless_consumption" = mkMount {
        local_path = "paperless_consumption";
      };
    };
  };
}
