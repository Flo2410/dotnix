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
    inputs.plasma-manager.homeManagerModules.plasma-manager
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

  services = {
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
      browser.ungoogled-chromium.enable = true;
      browser.zen = {
        enable = true;
        defaultBrowser = true;
        package = inputs.zen-browser.packages."${pkgs.system}".default;
      };
      virtualization = {
        enable = true;
        hasWin11 = lib.mkForce false;
      };
      vscode.enable = true;
      nvim.enable = true;

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
    bottles
    ente-auth
    heroic

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

    # (pkgs.makeDesktopItem {
    #   name = "flipper-lab";
    #   desktopName = "Flipper Lab";
    #   exec = "chromium --app=https://lab.flipper.net/";
    #   terminal = false;
    #   type = "Application";
    #   icon = pkgs.fetchurl {<
    #     url = "https://lab.flipper.net/icons/icon.svg";
    #     sha256 = "sha256-2SG0NJbOQHFuomJe5ANRbCSSNmkHOk2ZuZPtpVhsEfM=";
    #   };
    # })

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
