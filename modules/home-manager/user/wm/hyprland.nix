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
        };
      };

      app = {
        hyprlock = {
          # wallpaper = ../../../../wallpapers/framework/Abstract_1-hue_logo.jpg;
          wallpaper = config.stylix.image;
          enable = mkDefault true;
        };

        wlogout.enable = mkDefault true;
        waybar.enable = mkDefault true;
        rofi.enable = mkDefault true;
      };
    };


    services.hyprpaper.enable = mkDefault true;

    home.packages = with pkgs; [
      # meson
      wayland-utils
      wl-clipboard
      wlroots
      dunst
      networkmanagerapplet # GUI for networkmanager
      playerctl
      gnome.gnome-control-center
    ];

    wayland.windowManager.hyprland = {
      enable = mkForce true;

      settings = {
        "exec-once" = [

          # unlock kwallet
          "${pkgs.kwallet-pam}/libexec/pam_kwallet_init --no-startup-id"

          # networking
          "nm-applet --indicator &"

          "waybar &"
          "dunst" # notifications
        ];

        monitor = "eDP-1, preferred, 0x0, 1.175";

        input = {
          kb_layout = "at";
          kb_variant = "nodeadkeys";
          kb_options = "caps:escape";

          touchpad = {
            natural_scroll = true;
          };
        };

        gestures = {
          workspace_swipe = true;
        };

        general = {
          layout = "master";
        };

        "$mod" = "SUPER";
        bind =
          let
            # Sources:
            # https://github.com/fufexan/dotfiles/blob/a0bebadeb029ef50f2fa99ad3e7751a98b835610/home/programs/wayland/hyprland/binds.nix

            # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
            workspaces = builtins.concatLists (builtins.genList
              (x:
                let
                  ws = let c = (x + 1) / 10; in
                    builtins.toString (x + 1 - (c * 10));
                in
                [
                  "$mod, ${ws}, workspace, ${toString (x + 1)}"
                  "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                ]
              ) 10);

            toggle = program:
              let
                prog = builtins.substring 0 14 program;
              in
              "pkill ${prog} || ${program}";

            runOnce = config.lib.meta.runOnce;
          in
          [
            # --------------------------------
            # compositor commands
            # --------------------------------

            "$mod SHIFT, E, exec, pkill Hyprland"
            "$mod, Q, killactive,"
            # "$mod, F, fullscreen,"
            "$mod, G, togglegroup,"
            "$mod SHIFT, N, changegroupactive, f"
            "$mod SHIFT, P, changegroupactive, b"
            "$mod, R, togglesplit,"
            "$mod, F, togglefloating,"
            "$mod, P, pseudo,"
            "$mod ALT, ,resizeactive,"

            # --------------------------------
            # move focus
            # --------------------------------

            "$mod, left, movefocus, l"
            "$mod, right, movefocus, r"
            "$mod, up, movefocus, u"
            "$mod, down, movefocus, d"

            # --------------------------------
            # utility
            # --------------------------------

            # logout menu
            "$mod, Escape, exec, ${toggle "wlogout"} -p layer-shell"
            # lock screen
            "$mod, L, exec, ${runOnce "hyprlock"}"
            # open settings
            "$mod, U, exec, XDG_CURRENT_DESKTOP=gnome gnome-control-center"
            # open app launcher
            "ALT, SPACE, exec, ${toggle "rofi"} -show drun"

            # --------------------------------
            # programs
            # --------------------------------

            "$mod, RETURN, exec, kitty"
          ] ++ workspaces;


        bindl = [
          # media controls
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86AudioNext, exec, playerctl next"

          # volume
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ];

        bindle = [
          # volume
          ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-"

          # backlight
          ", XF86MonBrightnessUp, exec, brillo -q -u 300000 -A 5"
          ", XF86MonBrightnessDown, exec, brillo -q -u 300000 -U 5"
        ];

        # mouse movements
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
          "$mod ALT, mouse:272, resizewindow"
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
        ];
      };
    };
  };
}
