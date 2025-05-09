{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.app.hypridle;
in {
  options.user.app.hypridle = {
    enable = mkEnableOption "hypridle";
  };

  config = mkIf cfg.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          ignore_dbus_inhibit = false;
          lock_cmd = "${config.lib.meta.runOnce "hyprlock"}";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = [
            "(kill $(pidof hypridle) || true) && (pidof hypridle || hypridle)"
            "hyprctl dispatch dpms on"
          ];
        };

        listener = let
          bctl = "${pkgs.brightnessctl}/bin/brightnessctl";
        in [
          {
            timeout = 150; # 2.5 min
            on-timeout = "${bctl} --save && ${bctl} set 0"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = "${bctl} --restore"; # monitor backlight restore state.
          }
          # turn off keyboard backlight
          {
            timeout = 150; # 2.5 min
            on-timeout = "${bctl} --save -d chromeos::kbd_backlight && ${bctl} set 0 -d chromeos::kbd_backlight"; # turn off keyboard backlight.
            on-resume = "${bctl} --restore -d chromeos::kbd_backlight"; # restore keyboard backlight state.
          }
          {
            timeout = 300; # 5 min
            on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
          }
          {
            timeout = 330; # 5.5 min
            on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
            on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
          }
          {
            timeout = 600; # 10min
            on-timeout = "systemctl suspend-then-hibernate"; # suspend pc
          }
        ];
      };
    };
  };
}
