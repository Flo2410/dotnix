# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    outputs.homeManagerModules.user

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default
    inputs.plasma-manager.homeModules.plasma-manager
    inputs.catppuccin.homeModules.catppuccin
    inputs.ags.homeManagerModules.default
    inputs.nixvim.homeModules.nixvim

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    # ../../nix/nixpkgs.nix
    ../../nix/lib/functions.nix
    ../../config/home-manager/gaming.nix
  ];

  news.display = "silent"; # disable home-manager news

  services = {
    syncthing = {
      enable = true;
      tray = {
        enable = true;
        package = pkgs.syncthingtray-minimal;
        command = "syncthingtray --wait";
      };
    };

    kdeconnect.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs = {
    btop = {
      enable = true;
      package = pkgs.btop;
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
    wm.plasma.enable = true;

    shell.enable = true;

    config = {
      xdg.enable = true;
      ssh.enable = true;
      git.enable = true;
      docker.enable = true;
      flatpak.enable = true;
    };

    app = {
      vscode.enable = true;
      nvim.enable = true;
      go-hass-agent = {
        enable = true;
        customCommands = let
          kscreen-doctor = lib.getExe pkgs.kdePackages.libkscreen;
          steam = lib.getExe pkgs.steam;
          pactl = lib.getExe' pkgs.pulseaudio "pactl";
        in {
          button = [
            {
              name = "Display Profile Default";
              icon = "mdi:monitor-multiple";
              exec = "${kscreen-doctor} output.DP-1.enable output.DP-1.position.2560,1200 output.DP-1.priority.2 output.DP-2.enable output.DP-2.position.0,1440 output.DP-2.priority.1 output.DP-3.enable output.DP-3.position.0,0 output.DP-3.priority.3 output.HDMI-A-1.disable";
            }
            {
              name = "Display Profile Without Main";
              icon = "mdi:monitor-multiple";
              exec = "${kscreen-doctor} output.DP-1.enable output.DP-1.position.2560,1200 output.DP-1.priority.2 output.DP-3.enable output.DP-3.position.0,0 output.DP-3.priority.1 output.DP-2.disable output.HDMI-A-1.disable";
            }
            {
              name = "Display Profile TV";
              icon = "mdi:television";
              exec = "${kscreen-doctor} output.DP-1.disable output.DP-2.disable output.DP-3.disable output.HDMI-A-1.enable output.HDMI-A-1.position.0,0 output.HDMI-A-1.priority.1 output.HDMI-A-1.mode.3840x2160@120";
            }
            {
              name = "Open Steam Big Picture";
              icon = "mdi:television";
              exec = "${steam} -start steam://open/bigpicture -fulldesktopres";
            }
            {
              name = "Close Steam Big Picture";
              icon = "mdi:television";
              exec = "${steam} steam://close/bigpicture";
            }
            {
              name = "Set Audio Output Wohnzimmer TV";
              icon = "mdi:television";
              exec = "${pactl} set-default-sink alsa_output.pci-0000_01_00.1.hdmi-surround";
            }
            {
              name = "Set Audio Output Speaker";
              icon = "mdi:television";
              exec = "${pactl} set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo";
            }
            # FIXME: This does not work... but it should?
            # {
            #   name = "Minimize Apps";
            #   icon = "mdi:television";
            #   exec = "${lib.getExe' pkgs.kdePackages.qttools "qdbus"} org.kde.KWin /KWin org.kde.KWin.showDesktop true";
            # }
          ];
        };
      };

      browser = {
        ungoogled-chromium.enable = true;

        zen = {
          enable = true;
          defaultBrowser = true;
          enableUrlHandler = true;
          package = inputs.zen-browser.packages."${pkgs.system}".default;
        };
      };

      virtualization = {
        enable = true;
        hasWin11 = lib.mkForce false;
      };

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
    signal-desktop-bin
    prusa-slicer
    libreoffice
    obsidian
    remmina
    jabref
    ente-auth
    heroic
    home-assistant-desktop
    netbird-ui

    # games
    # modrinth-app

    # kde utils
    kdePackages.kcalc
    kdePackages.skanpage

    # Media
    gimp
    inkscape
    vlc
    ffmpeg
    nomacs

    # utils
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
    alejandra # nix fmt
    distrobox
    btrfs-assistant
    naps2

    (unstable.bottles.override {
      removeWarningPopup = true;
    })

    # PWAs
    (pkgs.makeDesktopItem {
      name = "whatsapp-web";
      desktopName = "WhatsApp";
      exec = "chromium --app=https://web.whatsapp.com --class=whatsapp";
      terminal = false;
      type = "Application";
      icon = "whatsapp";
      startupWMClass = "chrome-web.whatsapp.com__-Default";
      categories = ["Network" "InstantMessaging"];
    })

    (pkgs.makeDesktopItem {
      name = "onshape";
      desktopName = "Onshape";
      exec = "chromium --app=https://cad.onshape.com --class=onshape";
      terminal = false;
      type = "Application";
      icon = pkgs.fetchurl {
        url = "https://www.onshape.com/favicon.png";
        sha256 = "sha256-nMzyckYEemjYGGe2pd87zBOSWUseBW5s1plL0+3ZbV0=";
      };
      startupWMClass = "chrome-cad.onshape.com__-Default";
      categories = ["Utility" "Office"];
    })

    # Bottles
    (stdenv.mkDerivation {
      name = "lightroom-classic";
      dontUnpack = true;

      mimeConfig = pkgs.writeTextFile {
        name = "lightroom-classic.xml";
        text = ''
          <?xml version="1.0" encoding="utf-8"?>
          <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
            <mime-type type="application/x-lightoom-catalog">
              <glob pattern="*.lrcat"/>
              <comment>Lightroom Catalog</comment>
              <icon name="lightroom-classic" />
            </mime-type>
          </mime-info>
        '';
      };

      icon = pkgs.fetchurl {
        url = "https://www.adobe.com/cc-shared/assets/img/product-icons/svg/lightroom-classic-64.svg";
        sha256 = "sha256-KsY93/6LbwrrQjA8699s6f5pDJwUMpg3hdpuwEw78WU=";
      };

      desktopItem = pkgs.makeDesktopItem {
        name = "lightroom-classic";
        desktopName = "Lightroom Classic";
        exec = ''bottles-cli run -p "Lightroom Classic" -b "Adobe Lightroom" -- %u'';
        terminal = false;
        type = "Application";
        icon = "lightroom-classic";
        comment = "Launch Lightroom Classic using Bottles.";
        startupWMClass = "Lightroom Classic";
        mimeTypes = ["application/x-lightoom-catalog"];
        categories = ["Graphics"];
        actions.configure = {
          name = "Configure in Bottles";
          exec = ''bottles -b "Adobe Lightroom"'';
        };
      };

      installPhase = ''
        install -Dm644 $icon $out/share/icons/hicolor/scalable/apps/lightroom-classic.svg
        install -Dm644 $mimeConfig $out/share/mime/packages/lightroom-classic.xml
        install -Dm644 $desktopItem/share/applications/* -t $out/share/applications
      '';
    })

    # Shell scrips
    mkshell
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
