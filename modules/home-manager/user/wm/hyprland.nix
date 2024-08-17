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
          # initialize wallpaper daemon
          #swww-daemon &
          # set wallpaper
          #swww img ${../../../../wallpapers/framework/Abstract_1-hue_logo.jpg} &

          # networking
          nm-applet --indicator &

          waybar &
          dunst & # notifications
        ''}";

        monitor = "eDP-1, preferred, 0x0, 1.25";

        input = {
          kb_layout = "at";
          kb_variant = "nodeadkeys";
          kb_options = "caps:escape";

          touchpad = {
            natural_scroll = true;
          };
        };


        "$mod" = "SUPER";
        bind =
          [
            "$mod, SPACE, exec, rofi -show drun"
            "$mod, RETURN, exec, kitty"
          ];
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

  };
}
