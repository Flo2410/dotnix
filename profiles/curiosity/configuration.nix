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

  nixpkgs = {
    hostPlatform = "aarch64-linux";

    overlays = [
      (final: super: {
        makeModulesClosure = x:
          super.makeModulesClosure (x // { allowMissing = true; });
      })
    ];
  };



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

  security = {
    sudo.enable = true;
    pam = {
      enableSSHAgentAuth = true;
      services.sudo.sshAgentAuth = true;
    };
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
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII6VPoeosGDVKtBBCxo+IxqEA4p19hMDvhg45/glNUQU florian@fwf" ];
      hashedPassword = "$y$j9T$rtJSZcD91hnqnEKWagFDi/$vBeAzDioMpqdnGKZngkirJBI3jFrITdKNHqyvjsFUQB";
    };
  };

  # I use zsh btw
  environment.shells = with pkgs; [ zsh ];
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






