{}: {
  # --------------------------------
  # left
  # --------------------------------

  "hyprland/workspaces" = {
    disable-scroll = true;
    sort-by = "id";
  };

  # --------------------------------
  # center
  # --------------------------------
  clock = {
    interval = 1;
    format = "{:%d.%m.%Y | %H:%M:%S}";
    max-length = 25;
    tooltip-format = "<tt><small>{calendar}</small></tt>";
    calendar = {
      mode = "month";
    };
  };

  mpris = {
    format = "{player_icon} {artist} // {title}";
    format-paused = "{status_icon} {artist} // {title}";
    title-len = 20;
    player-icons = {
      default = "";
      spotify = "";
    };
    status-icons.paused = "";
    # ignored-players = [
    #   "firefox"
    # ];
  };

  # --------------------------------
  # right
  # --------------------------------

  tray = {
    icon-size = 20;
    spacing = 10;
  };

  backlight = {
    device = "intel_backlight";
    format = "{percent}% 󰃟";
    # format-icons = [ "" "" "" "" "" "" "" ];
    min-length = 7;
    on-click = "ags -b hypr -t quicksettings";
  };

  battery = {
    interval = 5;
    states = {
      warning = 30;
      critical = 15;
    };
    format = "{capacity}% {icon}";
    format-charging = "{capacity}% {icon}󱐋";
    format-plugged = "{capacity}% {icon}󱐋";
    format-alt = "{time} {icon}";
    # format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
    format-icons = ["" "" "" "" ""]; # Font Awesome
    # on-click = "ags -b hypr -t powerctrl";
  };

  pulseaudio = {
    format = "{icon}";
    format-bluetooth = "󰂰";
    nospacing = 1;
    tooltip-format = "Volume : {volume}%";
    format-muted = "󰝟";
    format-icons = {
      eadphone = "";
      default = ["󰖀" "󰕾"];
    };
    scroll-step = 1;
    on-click = "pavucontrol";
  };
}
