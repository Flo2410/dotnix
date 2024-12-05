{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.app.wlogout;
  runOnce = config.lib.meta.runOnce;
in {
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
          keybind = "l";
          action = "${runOnce "hyprlock"}";
        }
        {
          label = "logout";
          text = "Logout";
          action = "hyprctl dispatch exit 1";
        }
        {
          label = "suspend";
          text = "Suspend";
          keybind = "s";
          action = "systemctl suspend-then-hibernate";
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
          keybind = "d";
          action = "systemctl poweroff";
        }
        {
          label = "reboot";
          text = "Reboot";
          keybind = "r";
          action = "systemctl reboot";
        }
      ];

      style = ''
        * {
          background-image: none;
          box-shadow: none;
        }

        window {
          background-color: #11111b;
        }

        button {
          margin: 15rem 8px;
          border-radius: 10px;
          border-color: black;
          text-decoration-color: #FFFFFF;
          color: #FFFFFF;
          background-color: #181825;
          border-style: solid;
          border-width: 1px;
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;
        }

        button:focus, button:active, button:hover {
          background-color: #74c7ec;
          outline-style: none;
        }

        #lock {
          background-image: url("${pkgs.wlogout}/share/wlogout/icons/lock.png");
        }

        #logout {
          background-image: url("${pkgs.wlogout}/share/wlogout/icons/logout.png");
        }

        #suspend {
          background-image: url("${pkgs.wlogout}/share/wlogout/icons/suspend.png");
        }

        #hibernate {
          background-image: url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png");
        }

        #shutdown {
          background-image: url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png");
        }

        #reboot {
          background-image: url("${pkgs.wlogout}/share/wlogout/icons/reboot.png");
        }
      '';
    };
  };
}
