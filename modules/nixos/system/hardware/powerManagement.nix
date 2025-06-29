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
      # sudo findmnt -no UUID -T /swap/swapfile
      boot.resumeDevice = "/dev/disk/by-uuid/62f508d6-bd71-4c41-8e81-13d152f898aa"; # TODO Get uuid from hardware-config
      # sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
      boot.kernelParams = [
        # TODO: get offset from option
        "resume_offset=533760" # get the offset with ``sudo filefrag -v /swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}'`` https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Acquire_swap_file_offset
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
