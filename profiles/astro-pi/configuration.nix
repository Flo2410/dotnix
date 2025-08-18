# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    outputs.nixosModules.system

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd
    inputs.nixos-hardware.nixosModules.raspberry-pi-5
    inputs.stylix.nixosModules.stylix
    inputs.catppuccin.nixosModules.catppuccin
    "${inputs.nixpkgs}/nixos/modules/profiles/minimal.nix"

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

  nixpkgs = {
    hostPlatform = "aarch64-linux";

    overlays = [
      (final: super: {
        makeModulesClosure = x:
          super.makeModulesClosure (x // {allowMissing = true;});
      })
    ];
  };

  # Enable networking
  networking = {
    hostName = "astro-pi";
    networkmanager.enable = true;
    resolvconf.enable = true;
    # wireless = {
    #   interfaces = [ "wlan0" ];
    #   enable = true;
    # };
  };

  hardware.graphics = {
    enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  console.useXkbConfig = true;

  # "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix" creates a
  # disk with this label on first boot. Therefore, we need to keep it. It is the
  # only information from the installer image that we need to keep persistent
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  security = {
    sudo.enable = lib.mkForce false;
    sudo-rs = {
      enable = lib.mkForce true;
    };

    pam = {
      sshAgentAuth.enable = true;
      services.sudo.sshAgentAuth = true;
    };
  };

  environment = {
    # List packages installed in system profile.
    systemPackages = with pkgs; [
      wget
      git
      nushell
      home-manager

      libraspberrypi
      raspberrypi-eeprom

      gnome-tweaks
    ];

    shells = with pkgs; [nushell];

    gnome.excludePackages = with pkgs; [
      gnome-photos
      gnome-tour
      gnome-connections
      baobab
      cheese # webcam tool
      gnome-music
      epiphany # web browser
      geary # email reader
      gnome-characters
      yelp # Help view
      totem # Videos
      evince # document viewer
      gnome-contacts
      gnome-initial-setup
      gnome-maps
      gnome-weather
      gnome-calendar
      simple-scan
      gnome-font-viewer
      gnome-disk-utility
      gnome-logs
      gnome-calculator
    ];
  };

  home-manager = {
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
      extraGroups = ["networkmanager" "wheel" "input" "dialout" "video" "libvirtd" "docker"];
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFVOdHnkDkw2gYSmHUlBmn4LHEr7U72juMM92jOOBAez florian@PC-Florian"];
      hashedPassword = "$y$j9T$rtJSZcD91hnqnEKWagFDi/$vBeAzDioMpqdnGKZngkirJBI3jFrITdKNHqyvjsFUQB";
    };
  };

  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/florian/dotnix"; #FIXME: Get path from home.nix or someother global way.
    };

    ssh = {
      startAgent = true;
      enableAskPassword = true;
    };
  };

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

    # Configure keymap in X11
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      excludePackages = [pkgs.xterm];

      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      xkb.layout = "at";
      xkb.variant = "nodeadkeys";
    };

    gnome.games.enable = false;
  };

  system = {
    # Config
    config = {
      dbus.enable = true;
      fonts.enable = true;
      pipewire.enable = true;

      locale = {
        enable = true;
        defaultLocale = "en_GB.UTF-8";
        extraLocale = "de_AT.UTF-8";
      };
    };

    # Security
    security.firewall.enable = false;

    # Apps
    app = {
      docker = {
        enable = true;
        storageDriver = "overlay2";
      };
    };

    hardware = {
      bluetooth.enable = false;

      powerManagement = {
        enable = true;
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
