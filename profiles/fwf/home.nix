# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: rec {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    outputs.homeManagerModules.user

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default
    inputs.plasma-manager.homeManagerModules.plasma-manager
    # inputs.stylix.homeManagerModules.stylix # Not needed here as it is bundeled into the nixos module
    inputs.catppuccin.homeModules.catppuccin
    inputs.ags.homeManagerModules.default
    inputs.nixvim.homeManagerModules.nixvim

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    # ../../nix/nixpkgs.nix
    ../../nix/lib/functions.nix
    ../../config/home-manager/gaming.nix
  ];

  news.display = "silent"; # disable home-manager news

  home.sessionVariables = {
    SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
  };

  services = {
    syncthing = {
      enable = true;
      tray = {
        enable = true;
        package = pkgs.syncthingtray-minimal;
        command = "syncthingtray --wait";
      };
    };
    gnome-keyring = {
      enable = true;
      components = ["secrets" "ssh" "pkcs11"];
    };
    kdeconnect.enable = true;

    ssh-agent.enable = lib.mkForce false; # Disable ssh-agent, I use the one from gnome-keyring
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs = {
    btop = {
      enable = true;
      package = pkgs.btop-rocm;
    };
  };

  user = {
    home = rec {
      enable = true;
      username = "florian";
      homeDirectory = "/home/${username}";
      dotfilesDirectory = "${homeDirectory}/dotnix";
    };

    # WM
    wm.hyprland.enable = lib.mkDefault true;

    shell.enable = true;

    config = {
      xdg.enable = true;
      ssh.enable = true;
      git.enable = true;
      docker.enable = true;
      flatpak.enable = true;

      autostart = {
        enable = true;
        autostartItems = [];
      };
    };

    app = {
      browser.ungoogled-chromium.enable = true;
      browser.zen = {
        enable = true;
        defaultBrowser = true;
        package = inputs.zen-browser.packages."${pkgs.system}".default;
      };
      virtualization.enable = true;
      vscode.enable = true;
      matlab.enable = true;
      xilinx-vivado.enable = true;
      thunar.enable = true;
      nvim.enable = true;
      baloo.enable = true;

      terminal = {
        kitty.enable = true;
      };
    };
  };

  home.packages = with pkgs; [
    # programms
    thunderbird
    discord
    spotify
    prusa-slicer
    libreoffice-qt
    obsidian
    pulseview
    (signal-desktop-bin.overrideAttrs (old: {
      postFixup = ''
        # add gnome-keyring to launch args
        substituteInPlace $out/share/applications/signal.desktop \
          --replace "%U" "--password-store=\"gnome-libsecret\" %U"
      '';
    }))
    remmina
    insomnia
    wireshark
    bitwarden-desktop
    freecad-wayland
    blender
    zotero
    jabref
    bottles
    stm32cubemx
    ente-auth
    qgis
    modrinth-app

    # kde utils
    kdePackages.kcalc
    kdePackages.skanpage
    kdePackages.systemsettings
    kdePackages.print-manager
    kdePackages.ark
    kdePackages.okular

    # Media
    gimp
    inkscape
    darktable
    vlc
    ffmpeg
    nomacs
    moonlight-qt

    # utils
    syncthing
    gh
    ookla-speedtest
    xorg.xhost
    nixpkgs-fmt
    pre-commit
    file
    sshpass
    nixd
    font-manager
    pavucontrol
    yubikey-manager
    alejandra # nix fmt
    distrobox
    btrfs-assistant

    # unstable packages
    unstable.naps2
    unstable.saleae-logic-2
    unstable.parsec-bin

    # Custom Packages
    # home-assistant-desktop
    # elamx2

    # PWAs
    (pkgs.makeDesktopItem {
      name = "whatsapp-web";
      desktopName = "WhatsApp";
      exec = "chromium --app=https://web.whatsapp.com --class=whatsapp";
      terminal = false;
      type = "Application";
      icon = "whatsapp";
      startupWMClass = "whatsapp";
      categories = ["Network" "InstantMessaging"];
    })

    (pkgs.makeDesktopItem {
      name = "microsoft-teams";
      desktopName = "Microsoft Teams";
      exec = "chromium --app=https://teams.microsoft.com/go";
      terminal = false;
      type = "Application";
      icon = "teams";
    })

    (pkgs.makeDesktopItem {
      name = "flipper-lab";
      desktopName = "Flipper Lab";
      exec = "chromium --app=https://lab.flipper.net/";
      terminal = false;
      type = "Application";
      icon = pkgs.fetchurl {
        url = "https://lab.flipper.net/icons/icon.svg";
        sha256 = "sha256-2SG0NJbOQHFuomJe5ANRbCSSNmkHOk2ZuZPtpVhsEfM=";
      };
    })

    # Bottles
    (pkgs.makeDesktopItem {
      name = "catia-v5";
      desktopName = "CATIA V5";
      exec = ''bottles-cli run -p "CATIA V5" -b "CATIA" -- %u'';
      terminal = false;
      type = "Application";
      icon = ../../assets/icons/catia_icon.png;
      comment = "Launch CATIA V5 using Bottles.";
      startupWMClass = "CATIA V5";
    })

    # Shell scrips
    mkshell
  ];

  # specialisation = {
  #   plasma.configuration = {
  #     stylix.enable = lib.mkForce false;
  #     user.wm.hyprland.enable = lib.mkForce false;
  #     user.wm.plasma.enable = lib.mkForce true;
  #   };
  # };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
