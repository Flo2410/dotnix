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
    inputs.nixos-hardware.nixosModules.microsoft-surface-common
    # inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nix = {
    # Ensure nix flakes are enabled
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # Garbage collection
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };

    settings.trusted-users = ["florian"];
  };

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
  };

  # Enable networking
  networking = {
    hostName = "SurfacePro4"; # Define your hostname.
    networkmanager.enable = true;
  };

  hardware.graphics = {
    enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  console.useXkbConfig = true;

  documentation.nixos.enable = false;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    wget
    git
    zsh
    home-manager

    mesa-demos
    intel-gpu-tools

    surface-control
    gnome-tweaks

    (gnomeExtensions.gjs-osk.overrideAttrs (finalAttrs: previousAttrs: {
      src = fetchzip {
        url = "https://github.com/Vishram1123/gjs-osk/releases/download/29ec63e/gjsosk@vishram1123_main.zip";
        hash = "sha256-CEYkRIRdHlma/DuZUUaL6FzKBNerr5xFGMAcotvahV4=";
        stripRoot = false;
      };
    }))
  ];

  environment.gnome.excludePackages = with pkgs; [
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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    extraSpecialArgs = {inherit inputs outputs;};
    # sharedModules = builtins.attrValues outputs.homeManagerModules;
    users = {
      "florian" = import ./home.nix;
      "user" = import ./home-user.nix;
    };
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      "florian" = {
        isNormalUser = true;
        uid = 1000;
        extraGroups = ["networkmanager" "wheel" "input" "dialout" "video" "libvirtd" "docker"];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKQ9WvSMMooOnU1C++CpGVHsrM13vOYyl2zbTokBVP49 florian@PC-Florian"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIhpcNpe6K0Elbaf29mo1SLRUY+EQHKDv2xT9fslW6so florian@fwf"
        ];
      };

      "user" = {
        isNormalUser = true;
        uid = 1001;
        extraGroups = ["input" "video"];
        hashedPassword = ""; # Allow uset to login without a password.
        shell = pkgs.bash;
      };
    };
  };

  # I use zsh btw
  environment.shells = with pkgs; [zsh];
  programs.zsh.enable = true;

  security = {
    sudo.enable = true;
    pam = {
      sshAgentAuth.enable = true;
      services.sudo.sshAgentAuth = true;
    };
  };

  services = {
    timesyncd.enable = true;

    udev = {
      enable = true;
      packages = [
        pkgs.iptsd
        pkgs.surface-control
      ];
    };

    journald = {
      extraConfig = "SystemMaxUse=50M\nSystemMaxFiles=5";
      rateLimitBurst = 500;
      rateLimitInterval = "30s";
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

      xkb.layout = "at";
      xkb.variant = "nodeadkeys";
    };

    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    gnome.games.enable = false;
  };

  systemd.packages = [
    pkgs.iptsd
  ];

  hardware = {
    microsoft-surface.kernelVersion = "stable";
  };

  system = {
    # Config
    config = {
      dbus.enable = true;
      fonts.enable = true;
      pipewire.enable = false;
      plymouth.enable = true;

      locale = {
        enable = true;
        defaultLocale = "en_US.UTF-8";
        extraLocale = "de_AT.UTF-8";
      };
    };

    # Security
    #security.firewall.enable = true;

    hardware = {
      printing.enable = true;

      powerManagement = {
        enable = true;
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
