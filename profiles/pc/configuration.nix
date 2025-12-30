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
    binfmt.emulatedSystems = ["aarch64-linux"]; # This is needed to build Raspberry Pi imgs
    kernelPackages = pkgs.linuxPackages_zen;

    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
      timeout = 1;
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

    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];

    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';

    kernel.sysctl = {
      "vm.swappiness" = 10;
    };
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
      extraGroups = ["networkmanager" "wheel" "input" "dialout" "video" "libvirtd" "docker" "adbusers"];
    };
  };

  programs = {
    partition-manager.enable = true;
    adb.enable = true;

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
    netbird = {
      enable = true;
      package = pkgs.unstable.netbird;
    };

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

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

    wivrn = {
      enable = true;
      openFirewall = true;

      # Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
      # will automatically read this and work with WiVRn (Note: This does not currently
      # apply for games run in Valve's Proton)
      defaultRuntime = true;

      # Run WiVRn as a systemd service on startup
      autoStart = true;

      # If you're running this with an nVidia GPU and want to use GPU Encoding (and don't otherwise have CUDA enabled system wide), you need to override the cudaSupport variable.
      package = pkgs.wivrn.override {cudaSupport = true;};

      # You should use the default configuration (which is no configuration), as that works the best out of the box.
      # However, if you need to configure something see https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md for configuration options and https://mynixos.com/nixpkgs/option/services.wivrn.config.json for an example configuration.
    };
  };

  security = {
    pam = {
      sshAgentAuth.enable = true;
      services = {
        sudo-rs.sshAgentAuth = true;
        login.kwallet.enable = true;
      };
    };

    sudo.enable = lib.mkForce false;
    sudo-rs = {
      enable = lib.mkForce true;
    };
  };

  hardware.xone.enable = true;

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

  specialisation = {
    gnome.configuration = {
      system = {
        wm.plasma.enable = lib.mkForce false;
        wm.gnome.enable = true;
      };

      home-manager = {
        users."florian".user = {
          wm.plasma.enable = lib.mkForce false;
          wm.gnome.enable = true;
        };
      };

      programs = {
        ssh.startAgent = lib.mkForce false;
      };
    };

    hyprland.configuration = {
      system = {
        wm.plasma.enable = lib.mkForce false;
        wm.hyprland.enable = lib.mkDefault true;
      };

      home-manager = {
        users."florian".user = {
          wm.plasma.enable = lib.mkForce false;
          wm.hyprland.enable = lib.mkForce true;
        };
      };

      security = {
        pam.services = {
          login.enableGnomeKeyring = true;
          login.kwallet.enable = lib.mkForce false;
        };
      };

      programs = {
        ssh.startAgent = lib.mkForce false;
      };

      services = {
        gnome.gnome-keyring.enable = true;
        gnome.gcr-ssh-agent.enable = true;
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
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
