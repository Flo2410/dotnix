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
    system.config = {
      stylix = {
        enable = true;
        theme = "catppuccin-mocha";
      };

      keyboard.enable = true;
    };

    environment.systemPackages = with pkgs; [
      unstable.hyprland
      unstable.xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      xwayland
      wayland-protocols
      hyprland-qt-support
      hyprland-qtutils
      brightnessctl
    ];

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-gtk
      ];
    };

    programs = {
      hyprland = {
        enable = mkForce true;
        package = pkgs.unstable.hyprland;
        portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
        withUWSM = mkDefault true;
        xwayland.enable = mkForce true;
      };
    };

    services = {
      greetd = {
        enable = true;
        settings = {
          default_session = lib.mkDefault {
            command = ''
              ${pkgs.tuigreet}/bin/tuigreet \
              --time  \
              --remember \
              --remember-session \
              --asterisks \
              --window-padding 1 \
              --theme "border=magenta;text=cyan;prompt=lightblue;time=red;action=blue;button=darkgray;container=black;input=lightcyan" \
              --time-format "%d.%m.%Y // %H:%M:%S" \
              --cmd "${pkgs.uwsm}/bin/uwsm start hyprland-uwsm-fixed.desktop";
            '';
            user = "greeter";
          };
        };
      };

      displayManager.sessionPackages = [
        (pkgs.writeTextFile {
          name = "hyprland-uwsm-fixed";
          text = ''
            [Desktop Entry]
            Name=Hyprland (UWSM)
            Comment=Hyprland compositor managed by UWSM
            Exec=${lib.getExe config.programs.uwsm.package} start -F -- /run/current-system/sw/bin/start-hyprland
            Type=Application
            DesktopNames=Hyprland
            Keywords=tiling;wayland;compositor;
          '';
          destination = "/share/wayland-sessions/hyprland-uwsm-fixed.desktop";
          derivationArgs = {
            passthru.providedSessions = ["hyprland-uwsm-fixed"];
          };
        })
      ];
    };
  };
}
