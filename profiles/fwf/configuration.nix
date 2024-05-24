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

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];

    # Configure your nixpkgs instance
    config.allowUnfree = true;
  };

  # Ensure nix flakes are enabled
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 10;
    efi.canTouchEfiVariables = true;
    timeout = 1;
  };

  # Enable networking
  networking.hostName = "fwf"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.extraHosts =
    ''
      10.94.31.11 terminal.fhwn.ac.at
    '';

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };
  console.useXkbConfig = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.florian = {
    isNormalUser = true;
    description = "Florian";
    extraGroups = [ "networkmanager" "wheel" "input" "dialout" "video" "libvirtd" ];
    uid = 1000;
    packages = [ ];
  };

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

  system = {

    # WM
    wm.x11-plasma.enable = true;

    # Config
    config = {
      dbus.enable = true;
      fonts.enable = true;
      pipewire.enable = true;
      plymouth.enable = true;
    };

    # Security
    security.firewall.enable = true;

    # Apps
    app = {
      logiops.enable = true;
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
        ];
      };
    };

  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
