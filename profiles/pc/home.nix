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
    wm.x11-plasma.enable = true;

    shell.enable = true;

    config = {
      xdg.enable = true;
      ssh.enable = true;
      git.enable = true;

      autostart = {
        enable = true;
        autostartItems = [ "yakuake" ];
      };
    };

    app = {
      browser.vivaldi.enable = true;
      virtualization.enable = true;
      barrier.enable = false;
      vscode.enable = true;

      terminal = {
        kitty.enable = true;
        konsole.enable = true;
      };
    };
  };

  home.packages = with pkgs; [
    # programms
    firefox
    thunderbird
    discord
    spotify
    signal-desktop
    parsec-bin
    prusa-slicer
    libreoffice-qt

    # games
    olauncher

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

    # utils
    gh
    ookla-speedtest
    xorg.xhost
    nixpkgs-fmt
    pre-commit
    file
    sshpass
    nixd

    # unstable packages
    #    unstable.kicad
    unstable.obsidian
    unstable.naps2

    # Remmina v1.4.30 
    remmina

    # Custom Packages
    home-assistant-desktop
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
