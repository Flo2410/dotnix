{}:
{
  windowrulev2 = [
    # make PiP window floating and sticky
    "float, title:^(Picture-in-Picture)$"
    "pin, title:^(Picture-in-Picture)$"
    "keepaspectratio, title:^(Picture-in-Picture)$"
    "suppressevent fullscreen, title:^(Picture-in-Picture)$"
    "suppressevent maximize, title:^(Picture-in-Picture)$"

    # Syncthing tray
    "float, title:^(Syncthing Tray)$"
    "size 640 320, title:^(Syncthing Tray)$"
    "move 100%-w-20 60, title:^(Syncthing Tray)$"
    "pin, title:^(Syncthing Tray)$"

    # elamx2
    "float, class:^(java-lang-Thread), title:^(Starting eLamX)(.*)$"
    "tile, class:^(java-lang-Thread), title:^(eLamX)(.*)$"

    # kwallet dialog
    "move onscreen cursor -50% -50%, floating: 1, class:^(org.kde.kwalletd6)$" # move window to cursor positon -> hack to get the window to the current display
    "center, floating: 1, class:^(org.kde.kwalletd6)$" # move the window to the center of the screen

    # MATLAB
    "tile, class:^(MATLAB)(.*), title:^(MATLAB)(.*)$" # Tile main window
    "float, class:^(MATLAB)(.*), title:^()$" # float everything else
    "center, class:^(MATLAB)(.*), title:^()$" # center everything else
    "tile, class:^(MATLAB)(.*), title:^(Figure)(.*)$" # tile figures

    # pavucontrol
    "float, class:^(pavucontrol), title:^(Volume Control)$"
  ];
}
