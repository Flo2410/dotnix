# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];

    config.allowUnfree = true;
  };

  # Home Manager needs a bit of information about you and the paths it should  manage.
  home = {
    username = "florian";
    homeDirectory = "/home/florian";
  };

  news.display = "silent"; # disable home-manager news

  programs.home-manager.enable = true;

  services = {
    syncthing.enable = true;
    kdeconnect.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.packages = with pkgs; [
    # programms
    firefox
    thunderbird
    discord
    spotify
    signal-desktop
    parsec-bin
    barrier
    matlab # from nix-matlab
    prusa-slicer
    onedrivegui
    saleae-logic-2
    libreoffice-qt

    # kde utils
    yakuake
    kate
    kcalc
    skanpage

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
    ansible
    sshpass
    nixd

    # unstable packages
    pkgs.unstable.kicad
    pkgs.unstable.obsidian
    pkgs.unstable.stm32cubemx
    pkgs.unstable.naps2

    # Remmina v1.4.30 
    # pkgs-remmina.remmina
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
