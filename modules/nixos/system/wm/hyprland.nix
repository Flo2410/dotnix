{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.system.wm.hyprland;
in
{

  options.system.wm.hyprland = {
    enable = mkEnableOption "Hyprland Desktop";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      hyprland
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      xwayland
      wayland-protocols

      sddm-astronaut
      # (catppuccin-sddm.override {
      #   flavor = "frappe";
      #   font = "Noto Sans";
      #   fontSize = "9";
      #   background = "${../../../../wallpapers/framework/Abstract_1-hue_logo.jpg}";
      #   loginBackground = true;
      # })
    ];

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    services = {
      xserver = {
        xkb = {
          layout = "at";
          variant = "nodeadkeys";
          options = "caps:escape";
        };
      };

      displayManager = {
        defaultSession = "hyprland";

        sddm = {
          enable = true;
          theme = "astronaut";
          wayland.enable = true;
          package = pkgs.kdePackages.sddm;
          extraPackages = with pkgs; [
            # Fix for astronaut theme
            qt6.qtsvg
            qt6.qt5compat
            qt6.qtdeclarative
          ];
        };
      };
    };
  };
}
