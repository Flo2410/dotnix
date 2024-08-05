# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    outputs.homeManagerModules.user

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default
    inputs.plasma-manager.homeManagerModules.plasma-manager

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    # ../../nix/nixpkgs.nix
    ../../nix/lib/functions.nix
  ];

  news.display = "silent"; # disable home-manager news

  services = {
    syncthing.enable = true;
    kdeconnect.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

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

      autostart = {
        enable = true;
        autostartItems = [ ];
      };
    };

    app = {
      browser.vivaldi.enable = true;
      browser.floorp = {
        enable = true;
        defaultBrowser = true;
      };
      virtualization.enable = true;
      latte.enable = true;
      barrier.enable = true;
      vscode.enable = true;

      terminal = {
        kitty.enable = true;
        konsole.enable = true;
      };
    };
  };

  home.packages = with pkgs; [
    # programms
    thunderbird
    discord
    spotify
    signal-desktop
    matlab # from nix-matlab
    prusa-slicer
    onedrivegui
    libreoffice-qt
    obsidian
    kicad
    pulseview

    # kde utils
    kdePackages.yakuake
    kdePackages.kcalc
    kdePackages.skanpage

    # Media
    gimp
    inkscape
    darktable
    vlc
    ffmpeg
    nomacs

    # utils
    syncthingtray
    syncthing
    gh
    ookla-speedtest
    xorg.xhost
    nixpkgs-fmt
    pre-commit
    file
    sshpass
    nixd

    # unstable packages
    (unstable.stm32cubemx.overrideAttrs (old: rec{
      desktopItem = makeDesktopItem {
        name = "STM32CubeMX";
        exec = "stm32cubemx";
        desktopName = "STM32CubeMX";
        categories = [ "Development" ];
        icon = "stm32cubemx";
        comment = old.meta.description;
        terminal = false;
        startupNotify = false;
        mimeTypes = [
          "x-scheme-handler/sgnl"
          "x-scheme-handler/signalcaptcha"
        ];
      };

      buildCommand = old.buildCommand + ''
        mkdir -p $out/share/applications
        cp ${desktopItem}/share/applications/*.desktop $out/share/applications
      '';
    }))
    unstable.naps2
    unstable.saleae-logic-2
    unstable.parsec-bin

    # Remmina v1.4.30 
    remmina

    # Custom Packages
    home-assistant-desktop
    elamx2
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
