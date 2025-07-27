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
    inputs.nixos-hardware.nixosModules.common-cpu-intel-cpu-only
    # inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.stylix.nixosModules.stylix
    inputs.catppuccin.nixosModules.catppuccin
    inputs.lanzaboote.nixosModules.lanzaboote

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    ../../nix/nixpkgs.nix
    ../../nix/lib/functions.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ../../config/nixos/hardware/nvidia/nvidia-stable-opengl
  ];

  nix = {
    # Ensure nix flakes are enabled
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
      timeout = 5;
    };

    initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      # "nvidia_uvm"
      # "nvidia_drm"
    ];

    kernelModules = ["nvidia"];

    kernelParams = [
      "nvidia_drm.fbdev=1" # Enables the use of a framebuffer device for NVIDIA graphics. This can be useful for certain configurations.
      "nvidia_drm.modeset=1" # Enables kernel modesetting for NVIDIA graphics. This is essential for proper graphics support on NVIDIA GPUs.
    ];
  };

  # Enable networking
  networking = {
    hostName = "PC-Florian"; # Define your hostname.
    networkmanager.enable = true;
    resolvconf.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  console.useXkbConfig = true;

  environment = {
    # List packages installed in system profile.
    systemPackages = with pkgs; [
      wget
      git
      nushell
      home-manager
    ];

    shells = with pkgs; [nushell];

    variables = {
      SSH_ASKPASS_REQUIRE = "prefer";
    };
  };

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
      extraGroups = ["networkmanager" "wheel" "input" "dialout" "video" "libvirtd" "docker"];
    };
  };

  programs = {
    partition-manager.enable = true;
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

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  services = {
    timesyncd.enable = true;

    udev = {
      enable = true;
      packages = with pkgs; [
        udev-stm32-named-tty #(callPackage ./stm32-named-tty.nix { })
        udev-saleae-logic #(callPackage ./saleae-logic.nix { })
        udev-ft232h
        openocd #(callPackage ./openocd.nix { })
      ];
    };

    journald = {
      extraConfig = "SystemMaxUse=50M\nSystemMaxFiles=5";
      rateLimitBurst = 500;
      rateLimitInterval = "30s";
    };

    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = ["/"];
    };

    displayManager.autoLogin = {
      enable = true;
      user = "florian";
    };
  };

  security = {
    pam.services.login.kwallet.enable = true;

    sudo.enable = lib.mkForce false;
    sudo-rs = {
      enable = lib.mkForce true;
    };
  };

  system = {
    # WM
    wm.plasma.enable = true;

    # Config
    config = {
      dbus.enable = true;
      fonts.enable = true;
      pipewire.enable = true;
      plymouth.enable = true;

      locale = {
        enable = true;
        defaultLocale = "en_GB.UTF-8";
        extraLocale = "de_AT.UTF-8";
      };
    };

    # Security
    security.firewall.enable = true;

    # Apps
    app = {
      steam.enable = true;
      virtualization.enable = true;

      docker = {
        enable = true;
        storageDriver = "overlay2";
      };

      flatpak = {
        enable = true;
        packages = [
          "com.ultimaker.cura"
          "com.github.tchx84.Flatseal"
        ];
      };
    };

    hardware = {
      bluetooth.enable = true;
      printing.enable = true;

      filesystem = {
        enable = true;
        autoMounts = ["/mnt/florian"];
      };

      powerManagement = {
        enable = lib.mkForce false;
        enableSuspendThenHibernate = true;
        resumeDevice = config.fileSystems."/swap".device;
        resumeOffset = 533760;
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
