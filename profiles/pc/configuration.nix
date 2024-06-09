# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs, outputs, lib, config, pkgs, ... }:

{
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    outputs.nixosModules.system

    # Or modules from other flakes (such as nixos-hardware):
    inputs.nixos-hardware.nixosModules.common-cpu-intel-cpu-only
    # inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    ../../nix/nixpkgs.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ../../config/nixos/hardware/nvidia/nvidia-stable-opengl
  ];

  nix = {
    # Ensure nix flakes are enabled
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # Garbage collection
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };

  # Bootloader.
  boot = {
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

    kernelModules = [ "nvidia" ];

    kernelParams = [
      "nvidia_drm.fbdev=1" # Enables the use of a framebuffer device for NVIDIA graphics. This can be useful for certain configurations.
      "nvidia_drm.modeset=1" # Enables kernel modesetting for NVIDIA graphics. This is essential for proper graphics support on NVIDIA GPUs.
    ];
  };

  # Enable networking
  networking = {
    hostName = "PC-Florian"; # Define your hostname.
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  console.useXkbConfig = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    wget
    git
    zsh
    home-manager
  ];

  programs.partition-manager.enable = true;

  # I use zsh btw
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

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
    };

    journald = {
      extraConfig = "SystemMaxUse=50M\nSystemMaxFiles=5";
      rateLimitBurst = 500;
      rateLimitInterval = "30s";
    };

    displayManager.autoLogin = {
      enable = true;
      user = "florian";
    };
  };

  system = {

    # WM
    wm.x11-plasma.enable = true;

    # Config
    config = {
      dbus.enable = true;
      fonts.enable = true;
      pipewire.enable = true;
      plymouth.enable = true;

      locale = {
        enable = true;
        defaultLocale = "en_US.UTF-8";
        extraLocale = "de_AT.UTF-8";
      };

      user = {
        user = "florian";
        home-manager = {
          enable = true;
          home = ./home.nix;
        };
      };
    };

    # Security
    security.firewall.enable = true;

    # Apps
    app = {
      steam.enable = true;
      virtualization.enable = true;

      flatpak = {
        enable = true;
        packages = [
          "com.ultimaker.cura"
        ];
      };
    };

    hardware = {
      printing.enable = true;

      filesystem = {
        enable = true;
        autoMounts = [ "/mnt/florian" ];
      };

      #     powerManagement = {
      #       enable = true;
      #     };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
