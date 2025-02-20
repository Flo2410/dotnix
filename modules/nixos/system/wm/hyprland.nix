{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.wm.hyprland;
in {
  options.system.wm.hyprland = {
    enable = mkEnableOption "Hyprland Desktop";
  };

  config = mkIf cfg.enable {
    system.config.stylix = {
      enable = true;
      theme = "catppuccin-mocha";
    };

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
      #   background = "${../../../../assets/framework/Abstract_1-hue_logo.jpg}";
      #   loginBackground = true;
      # })
    ];

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    };

    hardware.brillo.enable = mkDefault true;

    programs.hyprland = {
      enable = mkForce true;
      withUWSM = true; # recommended for most users
      xwayland.enable = mkForce true;
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
        defaultSession = "hyprland-uwsm";

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
