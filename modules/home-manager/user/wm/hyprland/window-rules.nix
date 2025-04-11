{}: {
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
    "tile, class:^(MATLAB)(.*), title:^(Figure)(.*)$" # tile figures
    "tile, class:^(MATLAB)(.*), title:^(Scope)(.*)$" # tile Scope
    "float, class:^(MATLAB)(.*), title:^()$" # float everything else
    # "center, class:^(MATLAB)(.*), title:^()$" # center everything else

    # pavucontrol
    "float, class:^(pavucontrol), title:^(Volume Control)$"
    "move onscreen cursor -50% -50%, class:^(pavucontrol), title:^(Volume Control)$"
    "center, class:^(pavucontrol), title:^(Volume Control)$"

    # HomeAssistent desktop
    "float, class:^(Electron), title:^(.*)(Home Assistant)$"
    "move 100%-w-20 60, class:^(Electron), title:^(.*)(Home Assistant)$"
    "size 500 740, class:^(Electron), title:^(.*)(Home Assistant)$"
    "pin, class:^(Electron), title:^(.*)(Home Assistant)$"

    # Catia via bottles
    "float, class:^(cnext.exe)$"
    "tile, class:^(cnext.exe), title:^(CNEXT)$"

    # Thunderbird Identity Chooser
    "float, class:^(thunderbird), title:^(Identity Chooser)(.*)$"
    "center, class:^(thunderbird), title:^(Identity Chooser)(.*)$"
    # Calendat entry
    "float, class:^(thunderbird), title:^(Edit Item)$"
    "center, class:^(thunderbird), title:^(Edit Item)$"

    # STM32CubeMX
    "float, class:^(com-st-microxplorer-maingui-STM32CubeMX), title:^(win0)$"
    "tile, class:^(com-st-microxplorer-maingui-STM32CubeMX), title:^(STM32CubeMX)(.*)$"

    # Special workspaces
    "workspace special:social, class:^(thunderbird|discord|signal|chrome-web.whatsapp.com.*)$"
    "group set, class:^(thunderbird|discord|signal|chrome-web.whatsapp.com.*)$"

    # XWayland Video Bridge
    "opacity 0.0 override, class:^(xwaylandvideobridge)$"
    "noanim, class:^(xwaylandvideobridge)$"
    "noinitialfocus, class:^(xwaylandvideobridge)$"
    "maxsize 1 1, class:^(xwaylandvideobridge)$"
    "noblur, class:^(xwaylandvideobridge)$"
    "nofocus, class:^(xwaylandvideobridge)$"
  ];
}
