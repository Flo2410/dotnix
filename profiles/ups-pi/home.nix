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
    inputs.stylix.homeModules.stylix

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    # ../../nix/nixpkgs.nix
    ../../nix/lib/functions.nix
  ];

  news.display = "silent"; # disable home-manager news

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

    app = {
      nvim.enable = true;
    };
  };

  home.packages = with pkgs; [
    file
    sshpass
    nixd

    # Tools
    iperf
    netdiscover
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
