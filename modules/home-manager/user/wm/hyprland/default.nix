{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.user.wm.hyprland;
in
{
  options.user.wm.hyprland = {
    enable = mkEnableOption "Hyprland Desktop";
  };

  config = mkIf cfg.enable {
    user = {
      config = {
        stylix = {
          enable = mkDefault true;
          theme = "catppuccin-mocha";
          wallpaper = ../../../../../assets/wallpapers/moon.jpg;
        };
      };

      app = {
        hyprlock = {
          wallpaper = config.stylix.image;
          enable = mkDefault true;
        };

        wlogout.enable = mkDefault true;
        waybar.enable = mkDefault true;
        rofi.enable = mkDefault true;
        hypridle.enable = mkDefault true;
        dunst.enable = mkDefault true;
        ags.enable = mkDefault true;
      };
    };

    services.hyprpaper.enable = mkDefault true;

    home.packages = with pkgs; [
      # meson
      wayland-utils
      wl-clipboard
      wlroots
      networkmanagerapplet # GUI for networkmanager
      playerctl
      gnome.gnome-control-center
      gnome.gnome-bluetooth
      libsForQt5.qt5.qtwayland # qt5-wayland
      kdePackages.qtwayland # qt6-wayland
      kdePackages.qtstyleplugin-kvantum
      kdePackages.qtsvg # dolphin needs this to show icons
      kdePackages.breeze-icons # qt/kde icon theme
      dracula-icon-theme # qt/kde icon theme
      qt6ct
      cliphist # clipboard history
      nwg-displays # display management
      hyprshot
    ];

    wayland.windowManager.hyprland = {
      enable = mkForce true;

      settings =
        let
          hypr_binds = import ./binds.nix { inherit pkgs config; };
          hypr_window_rules = import ./window-rules.nix { };

        in
        {
          source = [
            "~/.config/hypr/monitors.conf"
            "~/.config/hypr/workspaces.conf"
          ];

          "exec-once" = [

            # unlock kwallet
            "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init --no-startup-id && kwalletd6 &"

            # pollkit
            "sleep 2; ${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"

            # networking
            "nm-applet --indicator &"

            "waybar &"
            # notifications
            "dunst"
            # clipboard history
            "wl-paste --watch cliphist store"
          ];

          monitor = "eDP-1, preferred, 0x0, 1.175";

          xwayland = {
            force_zero_scaling = true;
          };

          input = {
            kb_layout = "at";
            kb_variant = "nodeadkeys";
            kb_options = "caps:escape";
            accel_profile = "flat";
            follow_mouse = 2; # Cursor focus will be detached from keyboard focus. Clicking on a window will move keyboard focus to that window.
            sensitivity = 0;

            touchpad = {
              natural_scroll = true;
              tap-to-click = true;
              tap-and-drag = true;
              drag_lock = true;
            };
          };

          gestures = {
            workspace_swipe = true;
          };

          general = {
            layout = "master";
            gaps_in = 3;
            gaps_out = 6;
          };

          decoration = {
            rounding = 8;
            drop_shadow = true;
          };

          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            middle_click_paste = false;
          };

          device = [
            {
              # Framework Laptop internal touchpad
              name = "pixa3854:00-093a:0274-touchpad";
              sensitivity = 0;
            }
            {
              # G Pro Wireless
              name = "logitech-g-pro-1";
              sensitivity = -0.2;
            }
          ];

          env = [
            # QT
            "QT_QPA_PLATFORM,wayland;xcb"
            "QT_QPA_PLATFORMTHEME,qt6ct"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
            "QT_AUTO_SCREEN_SCALE_FACTOR,1"
            "QT_STYLE_OVERRIDE,kvantum"

            # Toolkit Backend Variables
            "GDK_BACKEND,wayland,x11,*"
            "SDL_VIDEODRIVER,wayland"
            "CLUTTER_BACKEND,wayland"

            # XDG Specifications
            "XDG_CURRENT_DESKTOP,Hyprland"
            "XDG_SESSION_TYPE,wayland"
            "XDG_SESSION_DESKTOP,Hyprland"

            # Hyprshot
            "HYPRSHOT_DIR,${config.xdg.userDirs.pictures}/hyprshot"
          ];
        } // hypr_binds // hypr_window_rules;
    };
  };
}
