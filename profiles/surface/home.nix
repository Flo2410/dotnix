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

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    # ../../nix/nixpkgs.nix
    ../../nix/lib/functions.nix
  ];

  news.display = "silent"; # disable home-manager news

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;

      # `gnome-extensions list` for a list
      enabled-extensions = [
        "system-monitor@gnome-shell-extensions.gcampax.github.com"
        "gjsosk@vishram1123.com"
      ];
    };
  };

  user = {
    home = rec {
      enable = true;
      username = "florian";
      homeDirectory = "/home/${username}";
      dotfilesDirectory = "${homeDirectory}/dotnix";
    };

    shell.enable = true;

    config = {
      #      xdg.enable = true;
      ssh.enable = true;
      git.enable = true;
    };

    app = {
      browser.vivaldi.enable = true;
    };
  };

  home.packages = with pkgs; [
    # programms
    firefox
    spotify

    # programs
    vlc
    ffmpeg
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
