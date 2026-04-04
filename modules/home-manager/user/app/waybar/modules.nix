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

  bluetooth = {
    format-on = "󰂯";
    format-off = "󰂲";
    format-connected = "󰂱 {device_alias}";
    format-connected-battery = " {device_alias} {device_battery_percentage}%";
    tooltip-format = "{controller_alias}	{controller_address}  {num_connections} connected";
    tooltip-format-connected = "{controller_alias}	{controller_address}  {num_connections} connected  {device_enumerate}";
    tooltip-format-enumerate-connected = "{device_alias}	{device_address}";
    tooltip-format-enumerate-connected-battery = "{device_alias}	{device_address}	{device_battery_percentage}%";
    on-click = "overskride";
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
    tooltip-format = "Volume: {volume}%";
    format-muted = "󰝟";
    format-icons = {
      eadphone = "";
      default = ["󰖀" "󰕾"];
    };
    scroll-step = 1;
    on-click = "pavucontrol";
  };

  "custom/power" = {
    format = "";
    tooltip-format = "Power";
    on-click = "wlogout -p layer-shell -b 6";
  };
}
