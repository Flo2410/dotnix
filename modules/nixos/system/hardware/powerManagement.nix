{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.hardware.powerManagement;
in {
  options.system.hardware.powerManagement = {
    enable = mkEnableOption "Power anagement";
    enableSuspendThenHibernate = mkOption {
      type = types.bool;
      default = false;
    };
    resumeDevice = mkOption {
      type = types.str;
    };
    resumeOffset = mkOption {
      type = types.number;
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

    (mkIf cfg.enableSuspendThenHibernate {
      # hibernate
      # https://linuxize.com/post/create-a-linux-swap-file/
      # https://www.worldofbs.com/nixos-framework/#setting-up-hibernate
      # sudo findmnt -no UUID -T /swap/swapfile
      boot.resumeDevice = cfg.resumeDevice;
      # sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
      boot.kernelParams = [
        "resume_offset=${toString cfg.resumeOffset}" # get the offset with ``sudo filefrag -v /swap/swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}'`` https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Acquire_swap_file_offset
      ];

      # Suspend-then-hibernate everywhere
      services.logind = {
        settings = {
          Login = {
            HandleLidSwitch = "suspend-then-hibernate";
            HandlePowerKey = "suspend-then-hibernate";
          };
        };
      };

      systemd.sleep.extraConfig = "HibernateDelaySec=2h";
    })
  ];
}
