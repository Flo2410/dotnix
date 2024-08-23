{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.user.app.wlogout;
  runOnce = config.lib.meta.runOnce;

in
{
  options.user.app.wlogout = {
    enable = mkEnableOption "wlogout";
  };

  config = mkIf cfg.enable {
    programs.wlogout = {
      enable = cfg.enable;
      layout = [
        {
          label = "lock";
          text = "Lock";
          keybind = "";
          action = "${runOnce "hyprlock"}";
        }
        {
          label = "logout";
          text = "Logout";
          keybind = "";
          action = "echo logout";
        }
        {
          label = "suspend";
          text = "Suspend";
          keybind = "s";
          action = "$(${runOnce "hyprlock"} &) & systemctl suspend-then-hibernate";
        }
        {
          label = "hibernate";
          text = "Hibernate";
          keybind = "h";
          action = "systemctl hibernate";
        }
        {
          label = "shutdown";
          text = "Shutdown";
          keybind = "";
          action = "systemctl poweroff";
        }
        {
          label = "reboot";
          text = "Reboot";
          keybind = "r";
          action = "systemctl reboot";
        }
      ];
    };
  };
}
