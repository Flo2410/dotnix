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
      hyprland-qt-support
      hyprland-qtutils
      brightnessctl
    ];

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    };

    programs = {
      hyprland = {
        enable = mkForce true;
        withUWSM = mkDefault true;
        xwayland.enable = mkForce true;
      };

      uwsm.waylandCompositors.hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
    };

    services = {
      xserver = {
        xkb = {
          layout = "at";
          variant = "nodeadkeys";
          options = "caps:escape";
        };
      };

      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = ''
              ${pkgs.tuigreet}/bin/tuigreet \
              --time  \
              --remember \
              --remember-session \
              --asterisks \
              --window-padding 1 \
              --theme "border=magenta;text=cyan;prompt=lightblue;time=red;action=blue;button=darkgray;container=black;input=lightcyan" \
              --time-format "%d.%m.%Y // %H:%M:%S" \
              --cmd "${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop";
            '';
            user = "greeter";
          };
        };
      };
    };
  };
}
