{
  lib,
  pkgs,
  config,
  options,
  ...
}: let
  cfg = config.user.wm.hyprland;
in {
  options.user.wm.hyprland = {
    enable = lib.mkEnableOption "Hyprland Desktop";

    extraSettings = lib.mkOption {
      type = options.wayland.windowManager.hyprland.settings.type;
      default = {};
      description = "Extra Hyprland settings.";
    };
  };

  config = lib.mkIf cfg.enable {
    user = {
      config = {
        stylix = {
          enable = lib.mkDefault true;
          theme = "catppuccin-mocha";
          wallpaper = lib.mkDefault ../../../../../assets/wallpapers/moon.jpg;
        };
      };

      app = {
        hyprlock = {
          wallpaper = config.stylix.image;
          enable = lib.mkDefault true;
        };

        wlogout.enable = lib.mkDefault true;
        rofi.enable = lib.mkDefault true;
        hypridle.enable = lib.mkDefault true;
        dunst.enable = lib.mkDefault true;
        waybar.enable = lib.mkDefault true;

        ags.enable = lib.mkDefault false;
      };
    };

    stylix.targets = {
      kde.enable = lib.mkDefault true;
      hyprpaper.enable = lib.mkDefault true;
    };

    services = {
      hyprpaper.enable = lib.mkDefault true;

      swayosd = {
        enable = lib.mkDefault true;
      };
    };

    # https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/#nixos-uwsm
    xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

    home = {
      packages = with pkgs; [
        # meson
        wayland-utils
        wl-clipboard
        wlroots
        networkmanagerapplet # GUI for networkmanager
        networkmanager-openvpn
        playerctl
        gnome-control-center
        overskride
        libsForQt5.qt5.qtwayland # qt5-wayland
        kdePackages.qtwayland # qt6-wayland
        cliphist # clipboard history
        nwg-displays # display management
        hyprshot
      ];

      sessionVariables = {
        # QT
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
        QT_AUTO_SCREEN_SCALE_FACTOR = 1;
        QT_STYLE_OVERRIDE = "kvantum";

        # Toolkit Backend Variables
        GDK_BACKEND = "wayland,x11,*";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";

        # XDG Specifications
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_DESKTOP = "Hyprland";

        # Hyprshot
        HYPRSHOT_DIR = "${config.xdg.userDirs.pictures}/hyprshot";
      };
    };

    wayland.windowManager.hyprland = {
      enable = lib.mkForce true;
      package = null;
      portalPackage = null;

      systemd = {
        enable = lib.mkForce false;
        variables = ["--all"];
      };

      settings = let
        hypr_binds = import ./binds.nix {inherit pkgs config;};
      in
        lib.mkMerge [
          {
            source = [
              "~/.config/hypr/monitors.conf"
              "~/.config/hypr/workspaces.conf"
            ];

            "exec-once" = [
              # start gnome-key-daemon (not needed here, it's started by systemd (nixos configuration))
              #"${pkgs.gnome.gnome-keyring}/bin/gnome-keyring-daemon --start --components=secrets"

              # networking
              "nm-applet --indicator &"

              # notifications
              "dunst"
              # clipboard history
              "wl-paste --watch cliphist store"

              # ags
              (lib.mkIf config.user.app.ags.enable "start-ags")

              # https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
              "dbus-update-activation-environment --systemd --all"
            ];

            xwayland = {
              force_zero_scaling = true;
            };

            input = {
              kb_layout = "at-custom";
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

            # workspace_swipe = true;
            gesture = [
              "3, horizontal, workspace"
            ];

            general = {
              layout = "master";
              gaps_in = 3;
              gaps_out = 6;
              "col.active_border" = "$accent";
            };

            decoration = {
              rounding = 8;
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
              {
                # Apple magic trackpad via bluetooth
                name = "apple-inc.-magic-trackpad-2";
                sensitivity = 0.3;
              }
              {
                # Apple magic trackpad via usb
                name = "apple-inc.-magic-trackpad";
                sensitivity = 0.3;
              }
            ];

            animation = [
              "specialWorkspace, 1, 4, default, slidevert"
            ];

            group = {
              insert_after_current = false;
              drag_into_group = 1; # 0 (disabled), 1 (enabled), 2 (only when dragging into the groupbar)
              "col.border_active" = "$teal";
              "col.border_inactive" = "0xaa$tealAlpha";
              "col.border_locked_active" = "$maroon";
              "col.border_locked_inactive" = "0xaa$maroonAlpha";
            };

            "group:groupbar" = {
              enabled = true;
              "col.active" = "$surface0";
              "col.inactive" = "0xbf$surface0Alpha";
              "col.locked_active" = "$surface0";
              "col.locked_inactive" = "0xbf$surface0Alpha";
              text_color = "$maroon";
              font_size = 14;
              height = 20;
              indicator_height = 0;
              gradients = true;
              gradient_rounding = 8;
              # # keep_upper_gap = false;
            };

            windowrule = import ./window-rules.nix {};
          }
          hypr_binds
          cfg.extraSettings
        ];
    };
  };
}
