{ lib, pkgs, config, inputs, ... }:

with lib;
let
  cfg = config.user.wm.hyprland;
in
{

  options.user.wm.hyprland = {
    enable = mkEnableOption "Hyprland Desktop";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      # meson
      wayland-utils
      wl-clipboard
      wlroots
      dunst
      networkmanagerapplet # GUI for networkmanager
      waybar
      rofi-wayland
      hyprlock
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      settings = {
        # "exec-once" = [
        #   # initialize wallpaper daemon
        #   "swww init &"
        #   # set wallpaper
        #   "swww img ${../../../../wallpapers/framework/Abstract_1-hue_logo.jpg} &"

        #   # networking
        #   "nm-applet --indicator &"

        #   "waybar &"
        #   "dunst"
        # ];

        "exec-once" = "${pkgs.writeShellScript "init-hyprland" ''
          kwalletd6 &

          # networking
          nm-applet --indicator &

          waybar &
          dunst & # notifications
          
        ''}";

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
              (
                x:
                let
                  ws =
                    let
                      c = (x + 1) / 10;
                    in
                    builtins.toString (x + 1 - (c * 10));
                in
                [
                  "$mod, ${ws}, workspace, ${toString (x + 1)}"
                  "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                ]
              )
              10);

            toggle = program: service:
              let
                prog = builtins.substring 0 14 program;
                runserv = lib.optionalString service "run-as-service";
              in
              "pkill ${prog} || ${runserv} ${program}";

            runOnce = program: "pgrep ${program} || ${program}";
          in
          [
            # --------------------------------
            # compositor commands
            # --------------------------------

            "$mod SHIFT, E, exec, pkill Hyprland"
            "$mod, Q, killactive,"
            "$mod, F, fullscreen,"
            "$mod, G, togglegroup,"
            "$mod SHIFT, N, changegroupactive, f"
            "$mod SHIFT, P, changegroupactive, b"
            "$mod, R, togglesplit,"
            "$mod, T, togglefloating,"
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
            "$mod, Escape, exec, ${toggle "wlogout" true} -p layer-shell"
            # lock screen
            "$mod, L, exec, ${runOnce "hyprlock"}"
            # open settings
            "$mod, U, exec, XDG_CURRENT_DESKTOP=gnome gnome-control-center"
            # open app launcher
            "ALT, SPACE, exec, pkill rofi || rofi -show drun"

            # --------------------------------
            # programs
            # --------------------------------

            "$mod, RETURN, exec, kitty"
          ] ++ workspaces;
      };
    };

    services = {
      hyprpaper = {
        enable = true;
        settings = {
          preload = [ "${../../../../wallpapers/framework/Abstract_1-hue_logo.jpg}" ];
          wallpaper = [ ",${../../../../wallpapers/framework/Abstract_1-hue_logo.jpg}" ];
        };
      };
    };

    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          disable_loading_bar = true;
          hide_cursor = false;
          no_fade_in = true;
        };

        background = [
          {
            monitor = "";
            path = "${../../../../wallpapers/framework/Abstract_1-hue_logo.jpg}";
          }
        ];

      };
    };

  };
}
