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

    shell.enable = true;

    config = {
      xdg.enable = true;
      ssh.enable = true;
      git.enable = true;

      autostart = {
        enable = true;
        autostartItems = [ "OneDriveGUI" "yakuake" ];
      };
    };

    app = {
      browser.vivaldi.enable = true;
      fusuma.enable = true;
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
    firefox
    thunderbird
    discord
    spotify
    signal-desktop
    parsec-bin
    matlab # from nix-matlab
    prusa-slicer
    onedrivegui
    saleae-logic-2
    libreoffice-qt

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
    unstable.kicad
    unstable.obsidian
    unstable.stm32cubemx
    unstable.naps2

    # Remmina v1.4.30 
    remmina

    # Custom Packages
    home-assistant-desktop
    elamx2
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
