# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs, outputs, lib, config, pkgs, ... }:

rec {
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    outputs.nixosModules.system

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd
    inputs.nixos-wsl.nixosModules.default
    inputs.vscode-server.nixosModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    ../../nix/nixpkgs.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

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
  };

  # Enable networking
  networking = {
    hostName = "nixos"; # Define your hostname.
  };

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  console.useXkbConfig = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    git
    zsh
    home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    extraSpecialArgs = { inherit inputs outputs; };
    # sharedModules = builtins.attrValues outputs.homeManagerModules;
    users."florian" = import ./home.nix;
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users."florian" = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [ "networkmanager" "wheel" "input" "dialout" "video" "libvirtd" "docker" ];
    };
  };

  # I use zsh btw
  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;

  services = {
    timesyncd.enable = true;
    vscode-server.enable = true;
  };

  wsl = {
    enable = true;
    defaultUser = system.config.user.user;
    startMenuLaunchers = true;
    useWindowsDriver = true;
    docker-desktop.enable = false;

    wslConf = {
      automount.root = "/mnt";
      network.hostname = networking.hostName;
    };

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };

  system = {

    # Config
    config = {
      dbus.enable = true;
      fonts.enable = true;
      pipewire.enable = true;

      locale = {
        enable = true;
        defaultLocale = "en_US.UTF-8";
        extraLocale = "de_AT.UTF-8";
      };
    };

    hardware = {
      filesystem = {
        enable = true;
        autoMounts = [ "/mnt/florian" ];
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";

}
