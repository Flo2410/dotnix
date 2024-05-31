# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs, outputs, lib, config, pkgs, ... }:

{
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    outputs.nixosModules.system

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    "${inputs.nixpkgs}/nixos/modules/profiles/minimal.nix"

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    ../../nix/nixpkgs.nix

    # Import your generated (nixos-generate-config) hardware configuration
    # ./hardware-configuration.nix
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

  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];


  # Enable networking
  networking = {
    hostName = "curiosity";
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

  # This causes an overlay which causes a lot of rebuilding
  environment.noXlibs = lib.mkForce false;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    wget
    git
    zsh

    libraspberrypi
    raspberrypi-eeprom
  ];

  # I use zsh btw
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
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

  system = {

    # Config
    config = {
      fonts.enable = true;
      pipewire.enable = true;

      locale = {
        enable = true;
        defaultLocale = "en_US.UTF-8";
        extraLocale = "de_AT.UTF-8";
      };

      user = {
        user = "florian";
        authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII6VPoeosGDVKtBBCxo+IxqEA4p19hMDvhg45/glNUQU florian@fwf" ];
        home-manager = {
          enable = true;
          home = ./home.nix;
        };
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
      bluetooth.enable = true;

      powerManagement = {
        enable = true;
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}






