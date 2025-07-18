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
    "tile, class:^(MATLAB)(.*), title:^(MATLAB)$" # Tile main window
    "tile, class:^(MATLAB)(.*), title:^(Figure)(.*)$" # tile figures
    "tile, class:^(MATLAB)(.*), title:^(Scope)(.*)$" # tile Scope
    "tile, class:^(MATLAB)(.*), title:^(Help)$" # tile Help
    "size 500 300, class:^(MATLAB)(.*), title:^(Help on)(.*)$" # set size of Help of *
    "center, floating:1, class:^(MATLAB)(.*), title:^()$" # center floating windows with no title (e.g. the "Package App" window)
    "move cursor 0 0, floating:1, class:^(MATLAB)(.*), title:^(.+)$" # move all floating windows to the cursor position
    "center, class:^(MATLAB)(.*), title:^(Command HistoryWindow)$" # center command history
    "float, class:^(MATLABWindow)(.*), title:^(Add-On Installer)$" # float Add-On Installer
    "center, class:^(MATLABWindow)(.*), title:^(Add-On Installer)$" # center Add-On Installer
    # Loading window
    # "float, class:^(MATLAB)(.*), title:^(MATLAB)$"
    # "center, class:^(MATLAB)(.*), title:^(MATLAB)$"
    # "float, class:^(MATLAB)(.*), title:^()$" # float everything else
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

    # Thunderbird
    # Identity Chooser
    "float, class:^(thunderbird), title:^(Identity Chooser)(.*)$"
    "center, class:^(thunderbird), title:^(Identity Chooser)(.*)$"
    "size 860 620, class:^(thunderbird), title:^(Identity Chooser)(.*)$"
    # Calendar entry
    "float, class:^(thunderbird), title:^(Edit Item)$"
    "center, class:^(thunderbird), title:^(Edit Item)$"
    # Empty title
    "float, class:^(thunderbird), title:^()$"

    # STM32CubeMX
    "float, class:^(com-st-microxplorer-maingui-STM32CubeMX), title:^(win0)$"
    "tile, class:^(com-st-microxplorer-maingui-STM32CubeMX), title:^(STM32CubeMX)(.*)$"

    # Special workspaces
    "workspace special:social, class:^(thunderbird|discord|signal|chrome-web.whatsapp.com.*)$"
    "group set lock always invade, floating:0, class:^(thunderbird|discord|signal|chrome-web.whatsapp.com.*)$"

    # XWayland Video Bridge
    "opacity 0.0 override, class:^(xwaylandvideobridge)$"
    "noanim, class:^(xwaylandvideobridge)$"
    "noinitialfocus, class:^(xwaylandvideobridge)$"
    "maxsize 1 1, class:^(xwaylandvideobridge)$"
    "noblur, class:^(xwaylandvideobridge)$"
    "nofocus, class:^(xwaylandvideobridge)$"

    # qFlipper
    "float, class:^(com.flipperdevices.), title:^(qFlipper)$"
    "noborder, class:^(com.flipperdevices.), title:^(qFlipper)$"
    "noblur, class:^(com.flipperdevices.), title:^(qFlipper)$"
    "noshadow, class:^(com.flipperdevices.), title:^(qFlipper)$"

    # Discord
    "noinitialfocus, class:^(discord), title:^(Discord Updater)$"
    "nofocus, class:^(discord), title:^(Discord Updater)$"

    # Ubisoft
    "tile, class:^(upc.exe), title:^(Ubisoft Connect)$"
    # Anno 1800
    "tile, class:^(anno1800.exe), title:^(Anno 1800)$"
    "fullscreenstate 2 0, class:^(anno1800.exe), title:^(Anno 1800)$"
    "suppressevent fullscreen, class:^(anno1800.exe), title:^(Anno 1800)$"
    "suppressevent fullscreenoutput, class:^(anno1800.exe), title:^(Anno 1800)$"
    "suppressevent maximize, class:^(anno1800.exe), title:^(Anno 1800)$"
    # "fullscreen, class:^(anno1800.exe), title:^(Anno 1800)$"

    # Thunar
    "float, class:^(thunar), title:^(Rename)(.*)$"
  ];
}
