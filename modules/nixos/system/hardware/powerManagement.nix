{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.system.hardware.powerManagement;
in
{
  options.system.hardware.powerManagement = {
    enable = mkEnableOption "Power anagement";
    enableSuspendThenHibernate = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      powerManagement = {
        enable = true;
        powertop.enable = true;
      };

      services.power-profiles-daemon.enable = true;
    })

    (mkIf (cfg.enable && cfg.enableSuspendThenHibernate) {
      # hibernate
      # https://linuxize.com/post/create-a-linux-swap-file/
      # https://www.worldofbs.com/nixos-framework/#setting-up-hibernate
      boot.resumeDevice = "/dev/disk/by-uuid/70d15a62-5c11-4c28-8d56-2a146ce36a0c";
      boot.kernelParams = [
        "resume_offset=44773376" # get the offset with ``sudo filefrag -v /swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}'`` https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Acquire_swap_file_offset
      ];

      # Suspend-then-hibernate everywhere
      services.logind = {
        lidSwitch = "suspend-then-hibernate";
        powerKey = "suspend-then-hibernate";
      };
      systemd.sleep.extraConfig = "HibernateDelaySec=2h";
    })
  ];
}

