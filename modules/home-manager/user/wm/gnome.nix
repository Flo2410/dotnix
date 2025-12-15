{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.user.wm.gnome;

  addExtenstions = extensionPkgs: {
    home.packages = extensionPkgs;
    dconf.settings."org/gnome/shell" = {
      enabled-extensions = map (x: x.extensionUuid) extensionPkgs;
    };
  };
in {
  options.user.wm.gnome = {
    enable = lib.mkEnableOption "GNOME Desktop";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      user = {
        config = {
          stylix = {
            enable = lib.mkDefault true;
            theme = "catppuccin-mocha";
            wallpaper = ../../../../assets/wallpapers/nixos-wallpaper.png;
          };
        };
      };

      stylix.opacity.terminal = lib.mkForce 1.0;

      home = {
        packages = with pkgs; [
          gnome-tweaks
          gnome-keyring
          nautilus
          gnome-system-monitor
        ];

        sessionVariables = {
          EDITOR = "nvim";
        };
      };

      xdg.terminal-exec = {
        enable = lib.mkDefault true;
        settings = {
          default = [
            "kitty.desktop"
          ];
        };
      };

      dconf = {
        enable = true;
        settings = {
          "org/gnome/desktop/input-sources" = {
            xkb-options = ["caps:escape"];
          };

          "org/gnome/desktop/interface" = {
            gtk-enable-primary-paste = false;
          };

          "org/gnome/mutter" = {
            experimental-features = [
              "scale-monitor-framebuffer" # Enables fractional scaling (125% 150% 175%)
              "variable-refresh-rate" # Enables Variable Refresh Rate (VRR) on compatible displays
              "xwayland-native-scaling" # Scales Xwayland applications to look crisp on HiDPI screens
            ];
            overlay-key = "Super_R"; # This effectivly disables the overlay
          };

          "org/gnome/desktop/wm/preferences" = {
            mouse-button-modifier = "<Super>";
          };

          # Keybinds
          "org/gnome/desktop/wm/keybindings" = {
            activate-window-menu = [];
            toggle-message-tray = [];
            close = ["<Super>q"];
            maximize = [];
            move-to-monitor-down = [];
            move-to-monitor-left = [];
            move-to-monitor-right = [];
            move-to-monitor-up = [];
            move-to-workspace-down = [];
            move-to-workspace-up = [];
            toggle-maximized = ["<Super>n"];
            unmaximize = [];
            restore-shortcuts = [];
            focus-active-notification = [];
            toggle-quick-settings = [];
          };

          "org/gnome/shell/keybindings" = {
            toggle-application-view = ["<Super>a"];
          };

          "org/gnome/settings-daemon/plugins/media-keys" = {
            search = ["<Alt>space"];
          };

          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            name = "kitty super";
            command = "kitty";
            binding = "<Super>Return";
          };

          # Configure individual extensions
          "org/gnome/shell/extensions/blur-my-shell" = {
            brightness = 0.75;
            noise-amount = 0;
          };

          "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
            blur = false;
          };

          "rg/gnome/shell/extensions/blur-my-shell/panel" = {
            blur = false;
          };

          "org/gnome/shell/extensions/just-perfection" = {
            quick-settings-dark-mode = false;
            quick-settings-night-light = false;
            quick-settings-airplane-mode = false;
            weather = false;
            startup-status = 0;
            power-icon = true;
            window-picker-icon = false;
          };

          "org/gnome/shell/extensions/vitals" = {
            show-storage = false;
            icon-style = 1;
            menu-centered = true;
          };

          "org/gnome/shell/extensions/dash-to-dock" = {
            dash-max-icon-size = 48;
            height-fraction = 0.9;
            hot-keys = false;
            custom-theme-shrink = true;
            disable-overview-on-startup = true;

            # autohide
            autohide = true;
            autohide-in-fullscreen = false;
            require-pressure-to-show = true;
            show-dock-urgent-notify = true;
            intellihide = true;
            intellihide-mode = "ALL_WINDOWS";
            animation-time = 0.1;
            hide-delay = 0.1;
            pressure-threshold = 100.0;

            # launcher
            show-favorites = true;
            show-running = true;
            show-trash = false;
            show-mounts = false;
          };

          "org/gnome/shell/extensions/mediacontrols" = {
            hide-media-notification = true;
            show-label = true;
            label-width = lib.hm.gvariant.mkUint32 0;
            scroll-labels = false;
            show-control-icons = false;
            extension-position = "Center";
            extension-index = lib.hm.gvariant.mkUint32 1;
            mouse-action-left = "SHOW_POPUP_MENU";
            mouse-action-middle = "NONE";
            mouse-action-right = "PLAY_PAUSE";
          };

          # application settings
          "org/gnome/nautilus/preferences" = {
            default-folder-viewer = "list-view";
          };
        };
      };
    }

    (addExtenstions (with pkgs.gnomeExtensions; [
      appindicator
      vitals
      blur-my-shell
      dash-to-dock
      just-perfection
      user-themes
      media-controls
    ]))
  ]);
}
