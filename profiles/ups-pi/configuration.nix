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
    inputs.stylix.nixosModules.stylix
    inputs.catppuccin.nixosModules.catppuccin

    ../../config/nixos/hardware/raspberry-pi-zero-w-2
    "${inputs.nixpkgs}/nixos/modules/profiles/minimal.nix"
    "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    ../../nix/nixpkgs.nix
    ../../nix/lib/functions.nix

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
    zsh

    libraspberrypi
    raspberrypi-eeprom
  ];

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = false;
    extraSpecialArgs = {inherit inputs outputs;};
    # sharedModules = builtins.attrValues outputs.homeManagerModules;
    users."florian" = import ./home.nix;
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users."florian" = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = ["networkmanager" "wheel" "input" "dialout"];
      openssh.authorizedKeys.keys = [];
      hashedPassword = "$y$j9T$rtJSZcD91hnqnEKWagFDi/$vBeAzDioMpqdnGKZngkirJBI3jFrITdKNHqyvjsFUQB";
    };
  };

  # I use zsh btw
  environment.shells = with pkgs; [zsh];
  programs.zsh.enable = true;

  services = {
    timesyncd.enable = true;

    udev = {
      enable = true;
      packages = with pkgs; [
      ];
    };

    # Enable SSH
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
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
      flake = "/home/florian/dotnix"; #FIXME: Get path from home.nix or someother global way.
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
