{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    outputs.nixosModules.system

    # Or modules from other flakes (such as nixos-hardware):

    ../../config/nixos/hardware/raspberry-pi-zero-w-2
    "${inputs.nixpkgs}/nixos/modules/profiles/minimal.nix"
    "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"

    # Import your generated (nixos-generate-config) hardware configuration
    # ./hardware-configuration.nix
  ];

  nix = {
    # Ensure nix flakes are enabled
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Enable networking
  networking = {
    hostName = "ups-pi";
    networkmanager.enable = true;
    # wireless = {
    #   interfaces = [ "wlan0" ];
    #   enable = true;
    # };

    firewall = {
      allowedTCPPorts = [
        8080 # zigbee2mqtt
      ];
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix" creates a
  # disk with this label on first boot. Therefore, we need to keep it. It is the
  # only information from the installer image that we need to keep persistent
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  security = {
    pam = {
      sshAgentAuth.enable = true;
      services = {
        sudo-rs.sshAgentAuth = true;
        sudo.sshAgentAuth = true;
      };
    };

    sudo.enable = lib.mkForce false;
    sudo-rs = {
      enable = lib.mkForce true;
    };
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    wget
    git
    nushell

    libraspberrypi
    raspberrypi-eeprom
  ];

  environment.shells = [pkgs.nushell];

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = false;
    extraSpecialArgs = {inherit inputs outputs;};
    # sharedModules = builtins.attrValues outputs.homeManagerModules;
    users."florian" = import ./home.nix;
  };

  users = {
    defaultUserShell = pkgs.nushell;
    users."florian" = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = ["networkmanager" "wheel" "input" "dialout"];
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFE6xZALwlkERURQ7V0HV0fjZM5m0nA051K7r27Y2RzR florian@PC-Florian"];
      hashedPassword = "$y$j9T$rtJSZcD91hnqnEKWagFDi/$vBeAzDioMpqdnGKZngkirJBI3jFrITdKNHqyvjsFUQB";
    };
  };

  services = {
    timesyncd.enable = true;

    udev = {
      enable = true;
      packages = [];
    };

    # Enable SSH
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };

    zigbee2mqtt = {
      enable = true;
      package = pkgs.unstable.zigbee2mqtt;
      dataDir = "/var/lib/zigbee2mqtt";
      settings = {
        homeassistant.enabled = true;
        frontend = {
          enabled = true;
          port = 8080;
        };
        serial = {
          port = "/dev/serial/by-id/usb-ITEAD_SONOFF_Zigbee_3.0_USB_Dongle_Plus_V2_20221129153156-if00";
          adapter = "ember";
          baudrate = 115200;
        };
        mqtt = {
          server = "mqtt://haos.hye.network:1883";
          base_topic = "zigbee2mqtt_ups-pi";
          user = "z2m";
          password = "Aviator5-Disown-Achiness";
        };
        advanced = {
          last_seen = "ISO_8601";
        };
        availability = {
          enabled = true;
        };
      };
    };
    promtail = {
      enable = true;
      configuration = {
        server = {
          http_listen_port = 3031;
          grpc_listen_port = 0;
        };
        positions = {
          filename = "/tmp/positions.yaml";
        };
        clients = [
          {url = "https://loki:loki1234@loki.lro.hye.network/loki/api/v1/push";}
        ];
        scrape_configs = [
          {
            job_name = "journal";
            journal = {
              max_age = "12h";
              labels = {
                job = "systemd-journal";
                host = "ups-pi";
              };
            };
            relabel_configs = [
              {
                source_labels = ["__journal__systemd_unit"];
                target_label = "unit";
              }
            ];
          }
        ];
      };
    };
  };

  power.ups = {
    enable = true;
    mode = "netserver";
    openFirewall = true;

    upsmon.enable = false;

    ups."UPS-PC-Florian" = {
      description = "Eaton 3S 850";
      # driver name from https://networkupstools.org/stable-hcl.html
      driver = "usbhid-ups";
      # usbhid-ups driver always use value "auto"
      port = "auto";
      directives = [];
    };

    upsd = {
      listen = [
        {
          address = "0.0.0.0";
          port = 3493;
        }
      ];
    };

    users."upsmon" = let
      passwordFile = pkgs.writeTextFile {
        name = "upsmod.pw";
        text = ''
          35baMx*pF9cc%B6$Hp5c*
        '';
      }; # It is okay to have the password here (but should probably be moved to a secret in the future) as the pi is not acessable from the internet.
    in {
      passwordFile = "${passwordFile}";
      upsmon = "primary";
    };
  };

  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = config.home-manager.users.florian.user.home.dotfilesDirectory;
    };
  };

  system = {
    # Config
    config = {
      locale = {
        enable = true;
        defaultLocale = "en_GB.UTF-8";
        extraLocale = "de_AT.UTF-8";
      };
    };

    # Security
    security.firewall.enable = true;

    hardware = {
      powerManagement = {
        enable = true;
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
