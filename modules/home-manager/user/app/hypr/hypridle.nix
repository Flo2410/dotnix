{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.user.app.hypridle;
in
{
  options.user.app.hypridle = {
    enable = mkEnableOption "hypridle";
  };

  config = mkIf cfg.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "${config.lib.meta.runOnce "hyprlock"}";
          before_sleep_cmd = "loginctl lock-session";
        };

        listener = [
          {
            timeout = 150; # 2.5 min
            on-timeout = "brillo -l -O && brillo -l -S 0"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = "brillo -l -I"; # monitor backlight restore.
          }
          # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
          {
            timeout = 150; # 2.5 min
            on-timeout = "brillo -k -c -S 0 && brillo -k -S 0"; # turn off keyboard backlight.
            on-resume = "brillo -k -S 50"; # turn on keyboard backlight.
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






