{}:


{
  # --------------------------------
  # left
  # --------------------------------

  "hyprland/workspaces" = {
    disable-scroll = true;
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
  };

  battery = {
    interval = 3;
    states = {
      warning = 30;
      critical = 15;
    };
    format = "{capacity}% {icon}";
    format-charging = "{capacity}% 󱐋";
    format-plugged = "{capacity}% 󱐋";
    # format-alt = "{time} {icon}";
    format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
    # format-icons = [ "" "" "" "" "" ]; # Font Awesome
    on-click = "ags -b hypr -t powerctrl";
  };
}
