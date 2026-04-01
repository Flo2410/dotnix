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
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    inputs.zen-browser.homeModules.beta

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

    ssh-agent.enable = lib.mkForce false; # Disable ssh-agent, I use the one from gnome-keyring
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home = {
    keyboard = null;

    sessionVariables = {
      SSH_AUTH_SOCK = "/run/user/1000/gcr/ssh";
    };
  };

  programs = {
    onlyoffice.enable = true;

    btop = {
      enable = true;
      package = pkgs.btop-cuda;
    };

    obs-studio = {
      enable = true;
      package = pkgs.obs-studio.override {
        config.cudaSupport = true;
      };
      plugins = with pkgs.obs-studio-plugins; [
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-gstreamer
        obs-vkcapture
      ];
    };
  };

  user = let
    monitorHDMI = "HDMI-A-1,3840x2160@119.88,0x0,1.0,bitdepth,10";
    monitorDP1 = "DP-1,1920x1080@60.0,2560x1253,1.0,transform,3";
    monitorDP2 = "DP-2,2560x1440@165.0,0x1441,1.0,bitdepth,10,vrr,2";
    monitorDP3 = "DP-3,2560x1440@59.95,0x0,1.0,bitdepth,10";
  in {
    home = rec {
      enable = true;
      username = "florian";
      homeDirectory = "/home/${username}";
      dotfilesDirectory = "${homeDirectory}/dotnix";
    };

    # WM
    wm.hyprland = {
      enable = lib.mkDefault true;
      extraSettings = {
        plugin = [
          "${pkgs.unstable.hyprlandPlugins.hy3}/lib/libhy3.so"
        ];

        monitor = [
          monitorHDMI
          "HDMI-A-1,disable"
          monitorDP1
          monitorDP2
          monitorDP3
        ];

        windowrule = [
          # Special workspaces
          "match:class ^(thunderbird|signal)$, workspace special:social"
          "match:class ^(thunderbird|signal)$, match:float false, group set lock always invade"

          # Media Workspace
          "match:class ^(spotify|discord|chrome-web.whatsapp.com.*)$, workspace name:media"
        ];

        workspace = [
          "name:media, monitor:desc:BNQ BenQ BL2780 ET49L04844SL0, default:true"
          "m[desc:BNQ BenQ BL2780 ET49L04844SL0], layout:hy3"
        ];
      };
    };

    shell.enable = true;

    config = {
      xdg.enable = true;
      ssh.enable = true;
      git.enable = true;
      flatpak.enable = true;

      stylix.wallpaper = ../../assets/wallpapers/nixos-wallpaper.png;
    };

    app = {
      zed-editor.enable = true;
      nvim.enable = true;
      mangohud.enable = true;
      thunar.enable = true;
      hypridle.enable = false;

      go-hass-agent = {
        enable = true;
        customCommands = let
          steam = lib.getExe pkgs.steam;
          pactl = lib.getExe' pkgs.pulseaudio "pactl";
          hyprMonitor = "${lib.getExe' pkgs.unstable.hyprland "hyprctl"} keyword monitor";
        in {
          button = [
            {
              name = "Display Profile Default";
              icon = "mdi:monitor-multiple";
              exec = pkgs.writeShellScript "go-hass-agent-cmd-display-profile-default" ''
                ${hyprMonitor} HDMI-A-1,disable
                ${hyprMonitor} ${monitorDP1}
                ${hyprMonitor} ${monitorDP2}
                ${hyprMonitor} ${monitorDP3}
              '';
            }
            {
              name = "Display Profile Without Main";
              icon = "mdi:monitor-multiple";
              exec = pkgs.writeShellScript "go-hass-agent-cmd-display-profile-without-main" ''
                ${hyprMonitor} HDMI-A-1,disable
                ${hyprMonitor} ${monitorDP1}
                ${hyprMonitor} DP-2,disable
                ${hyprMonitor} ${monitorDP3}
              '';
            }
            {
              name = "Display Profile TV";
              icon = "mdi:television";
              exec = pkgs.writeShellScript "go-hass-agent-cmd-display-profile-tv" ''
                ${hyprMonitor} ${monitorHDMI}
                ${hyprMonitor} DP-1,disable
                ${hyprMonitor} DP-2,disable
                ${hyprMonitor} DP-3,disable
              '';
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
              exec = "${pactl} set-default-sink alsa_output.pci-0000_78_00.6.analog-stereo";
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
          nvidiaSupport = true;
          package = inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default;
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

  home.packages = with pkgs;
    [
      # programms
      thunderbird
      discord
      spotify
      prusa-slicer
      libreoffice
      obsidian
      remmina
      ente-auth
      heroic
      home-assistant-desktop
      anydesk
      unstable.jabref
      unstable.netbird-ui

      (signal-desktop.overrideAttrs (old: {
        postFixup = ''
          # add gnome-keyring to launch args
          substituteInPlace $out/share/applications/signal.desktop \
            --replace "%U" "--password-store=\"gnome-libsecret\" %U"
        '';
      }))
      (kicad.overrideAttrs (oldAttrs: {
        makeWrapperArgs =
          oldAttrs.makeWrapperArgs
          ++ [
            "--unset __GLX_VENDOR_LIBRARY_NAME"
          ];
      }))

      # games
      # modrinth-app
      sidequest

      # kde utils
      kdePackages.kcalc
      kdePackages.skanpage

      # Media
      gimp
      inkscape
      vlc
      ffmpeg
      nomacs
      audacity
      darktable
      rawtherapee
      deepskystacker-bin

      # utils
      gh
      ookla-speedtest
      xhost
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
      uutils-coreutils-noprefix
      wlx-overlay-s

      (unstable.bottles.override {
        removeWarningPopup = true;
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
          sha256 = "sha256-j1wPsHIfhdpDAjzugoIGQgYuLNk446dZ6z+YXzxspUs=";
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
    ]
    ++ (let
      mkChromePWA = config.lib.meta.mkChromePWA;
    in [
      # PWAs
      (mkChromePWA {
        domain = "cad.onshape.com";
        version = "1.0";
        icon = pkgs.fetchurl {
          url = "https://www.onshape.com/favicon.png";
          sha256 = "sha256-nMzyckYEemjYGGe2pd87zBOSWUseBW5s1plL0+3ZbV0=";
        };
        desktopName = "Onshape";
        categories = ["Utility" "Office"];
      })

      (mkChromePWA {
        domain = "usevia.app";
        version = "1.0";
        icon = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/the-via/website/c816784b7788a2122ebcbc0046fbe0ffa0a07878/static/img/icon.png";
          sha256 = "sha256-4kBtqyIjFEW05KBGNJdGbYCcwdkOg0dMmCfWUyLn4mM=";
        };
        desktopName = "VIA";
        categories = ["Utility" "System"];
      })

      (mkChromePWA {
        domain = "web.whatsapp.com";
        version = "1.0";
        icon = "whatsapp";
        desktopName = "WhatsApp";
        categories = ["Network" "InstantMessaging"];
      })
    ]);

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
