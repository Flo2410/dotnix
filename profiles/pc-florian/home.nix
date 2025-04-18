# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
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
    inputs.stylix.homeManagerModules.stylix
    inputs.catppuccin.homeModules.catppuccin
    inputs.ags.homeManagerModules.default
    inputs.nixvim.homeManagerModules.nixvim

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ../../nix/nixpkgs.nix
    ../../nix/lib/functions.nix
  ];

  news.display = "silent"; # disable home-manager news

  nix = {
    package = pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
    nixPath = ["nixpkgs=flake:nixpkgs"];
  };

  home.sessionVariables = {
    SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
    QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
    QT_WAYLAND_DECORATION = "adwaita";
  };

  home.activation = {
    linkDesktopApplications = {
      after = ["writeBoundary" "createXdgUserDirectories"];
      before = [];
      data = ''
        rm -rf ${user.home.homeDirectory}/.nix-desktop-files
        rm -rf ${user.home.homeDirectory}/.local/share/applications/home-manager
        rm -rf ${user.home.homeDirectory}/.icons/nix-icons
        mkdir -p ${user.home.homeDirectory}/.nix-desktop-files
        mkdir -p ${user.home.homeDirectory}/.icons
        ln -sf ${user.home.homeDirectory}/.nix-profile/share/icons ${user.home.homeDirectory}/.icons/nix-icons
        /usr/bin/desktop-file-install ${user.home.homeDirectory}/.nix-profile/share/applications/*.desktop --dir ${user.home.homeDirectory}/.local/share/applications/home-manager
        sed -i 's/Exec=/Exec=\/home\/${user.home.username}\/.nix-profile\/bin\//g' ${user.home.homeDirectory}/.local/share/applications/home-manager/*.desktop
        /usr/bin/update-desktop-database ${user.home.homeDirectory}/.local/share/applications
      '';
    };
  };

  targets.genericLinux.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
    nh = {
      enable = true;
      flake = "${user.home.dotfilesDirectory}";
    };
  };

  nixGL = {
    packages = pkgs.nixgl;
    defaultWrapper = "mesa";
    installScripts = ["mesa"];
  };

  services = {
    gnome-keyring = {
      enable = true;
      components = ["secrets" "ssh"];
    };

    ssh-agent.enable = lib.mkForce false; # Disable ssh-agent, I use the one from gnome-keyring
  };

  user = {
    home = rec {
      enable = true;
      username = "florian";
      homeDirectory = "/var/home/${username}";
      dotfilesDirectory = "${homeDirectory}/dotnix";
    };

    shell.enable = true;

    config = {
      ssh.enable = true;
      git.enable = true;
      stylix = {
        enable = true;
        theme = "catppuccin-mocha";
        wallpaper = pkgs.fetchurl {
          url = "https://live.staticflickr.com/65535/53453268481_e80cfca2d4_o_d.jpg";
          sha256 = "sha256-LvNCxW00MHDuX6n/RgnyQbXd/cYKxi8h5dSY97ZwLzc=";
        };
      };
    };

    app = {
      browser.ungoogled-chromium.enable = true;
      vscode.enable = true;
      nvim.enable = true;

      terminal = {
        kitty = {
          enable = true;
          package = config.lib.nixGL.wrap pkgs.kitty;
        };
      };
    };
  };

  home.packages = with pkgs;
    [
      # programms
      libreoffice
      obsidian
      seahorse
      discord
      android-tools
      bottles

      kdePackages.okular

      # utils
      gh
      ookla-speedtest
      nixpkgs-fmt
      pre-commit
      file
      sshpass
      nixd
      font-manager
      pavucontrol
      alejandra # nix fmt

      # Media
      gimp
      inkscape
      darktable
      vlc
      ffmpeg
      nomacs

      # QT Stuff
      qadwaitadecorations
      qadwaitadecorations-qt6
      libsForQt5.qt5.qtwayland # qt5-wayland
      kdePackages.qtwayland # qt6-wayland

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
    ]
    ++ (map (pkg: config.lib.nixGL.wrap pkg) [
      ente-auth
      remmina
    ]);

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
