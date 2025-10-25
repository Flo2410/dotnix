{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
              attributes = [0]; # partition attribute
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f"]; # Override existing partition
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                  };

                  "/home" = {
                    mountOptions = ["compress=zstd"];
                    mountpoint = "/home";
                  };

                  "/nix" = {
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                    mountpoint = "/nix";
                  };

                  "/log" = {
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                    mountpoint = "/var/log";
                  };

                  # Subvolume for the swapfile
                  "/swap" = {
                    mountOptions = [
                      "noatime"
                    ];
                    mountpoint = "/swap";
                    swap = {
                      swapfile.size = "1024M";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
