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
    inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
    inputs.stylix.nixosModules.stylix
    inputs.catppuccin.nixosModules.catppuccin

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    ../../nix/nixpkgs.nix
    ../../nix/lib/functions.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
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
    binfmt.emulatedSystems = ["aarch64-linux"]; # This is needed to build Raspberry Pi imgs
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
  };

  # Enable networking
  networking = {
    hostName = "fwf"; # Define your hostname.
    networkmanager.enable = true;
    resolvconf.enable = true;
    extraHosts = ''
      10.94.31.11 terminal.fhwn.ac.at
    '';
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
    kdePackages.plasma-thunderbolt
    gparted
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Fix for vscode on wayland

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    extraSpecialArgs = {inherit inputs outputs;};
    # sharedModules = builtins.attrValues outputs.homeManagerModules;
    users."florian" = import ./home.nix;
  };

  users = {
    groups.plugdev = {};
    defaultUserShell = pkgs.zsh;
    users."florian" = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = ["networkmanager" "wheel" "input" "dialout" "video" "libvirtd" "docker" "plugdev" "wireshark"];
    };
  };

  programs = {
    zsh.enable = true;
    partition-manager.enable = true;
    seahorse.enable = true;
    wireshark.enable = true;
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/florian/dotnix"; #FIXME: Get path from home.nix or someother global way.
    };
  };

  # I use zsh btw
  environment.shells = with pkgs; [zsh];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
    ];
  };

  security = {
    polkit.enable = true;

    pam.services = {
      sddm.enableGnomeKeyring = true;
      login.enableGnomeKeyring = true;
      hyprlock = {};
    };
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  services = {
    hardware.bolt.enable = true;
    timesyncd.enable = true;
    gvfs.enable = true; # Thunar: Mount, trash, and other functionalities
    upower.enable = true;
    gnome.gnome-keyring.enable = true;

    udev = {
      enable = true;
      packages = with pkgs; [
        udev-stm32-named-tty #(callPackage ./stm32-named-tty.nix { })
        udev-saleae-logic #(callPackage ./saleae-logic.nix { })
        udev-ft232h
        openocd #(callPackage ./openocd.nix { })
        udev-xilinx-digilent-usb
        udev-xilinx-digilent-pcusb
      ];
    };

    journald = {
      extraConfig = "SystemMaxUse=50M\nSystemMaxFiles=5";
      rateLimitBurst = 500;
      rateLimitInterval = "30s";
    };
  };

  system = {
    # WM
    wm.hyprland.enable = lib.mkDefault true;

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
    };

    # Security
    security.firewall.enable = true;

    # Apps
    app = {
      logiops.enable = true;
      steam.enable = true;
      virtualization.enable = true;
      thunar.enable = true;

      docker = {
        enable = true;
        storageDriver = "overlay2";
      };

      flatpak = {
        enable = true;
        packages = [
          "com.ultimaker.cura"
          "org.kicad.KiCad"
          "com.github.tchx84.Flatseal"
        ];
      };
    };

    hardware = {
      bluetooth.enable = true;
      fingerprint.enable = true;
      kernelOptions.enable = true;
      opengl.enable = true;
      printing.enable = true;

      filesystem = {
        enable = true;
        autoMounts = ["/mnt/florian"];
      };

      powerManagement = {
        enable = true;
        enableSuspendThenHibernate = true;
      };
    };
  };

  # specialisation = {
  #   plasma.configuration = {
  #     stylix.enable = lib.mkForce false;
  #     stylix.image = ../../assets/framework/Abstract_1-hue_logo.jpg;
  #     system.wm.hyprland.enable = lib.mkForce false;
  #     system.wm.plasma.enable = lib.mkForce true;
  #   };
  # };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
