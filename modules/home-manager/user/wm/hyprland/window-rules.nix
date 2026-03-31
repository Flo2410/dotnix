{}: [
  # make PiP window floating and sticky
  "match:title ^(Picture-in-Picture)$, float on"
  "match:title ^(Picture-in-Picture)$, pin on"
  "match:title ^(Picture-in-Picture)$, keep_aspect_ratio on"
  "match:title ^(Picture-in-Picture)$, suppress_event fullscreen"
  "match:title ^(Picture-in-Picture)$, suppress_event maximize"

  # Syncthing tray
  "match:title ^(Syncthing Tray)$, float on"
  "match:title ^(Syncthing Tray)$, size 640 320"
  "match:title ^(Syncthing Tray)$, move 100%-w-20 60"
  "match:title ^(Syncthing Tray)$, pin on"

  # elamx2
  "match:class ^(java-lang-Thread), match:title ^(Starting eLamX)(.*)$, float on"
  "match:class ^(java-lang-Thread), match:title ^(eLamX)(.*)$, tile on"

  # kwallet dialog
  "match:float true, match:class ^(org.kde.kwalletd6)$, move onscreen cursor -50% -50%"
  "match:float true, match:class ^(org.kde.kwalletd6)$, center on"

  # MATLAB
  "match:class ^(MATLAB)(.*), match:title ^(.+)$, tile on"
  "match:class ^(MATLAB)(.*), match:title ^(MATLAB)( .*)$, float on"
  "match:class ^(MATLAB)(.*), match:title ^(MathWorks Update Installer)$, float on"
  "match:class ^(MATLAB)(.*), match:title ^(MathWorks Update Installer)$, center on"

  # pavucontrol
  "match:class ^(.*)(pavucontrol), match:title ^(Volume Control)$, float on"
  "match:class ^(.*)(pavucontrol), match:title ^(Volume Control)$, move onscreen cursor -50% -50%"
  "match:class ^(.*)(pavucontrol), match:title ^(Volume Control)$, center on"

  # Home Assistant desktop
  "match:class ^(Electron), match:title ^(.*)(Home Assistant)$, float on"
  "match:class ^(Electron), match:title ^(.*)(Home Assistant)$, move 100%-w-20 60"
  "match:class ^(Electron), match:title ^(.*)(Home Assistant)$, size 500 740"
  "match:class ^(Electron), match:title ^(.*)(Home Assistant)$, pin on"

  # Catia via bottles
  "match:class ^(cnext.exe)$, float on"
  "match:class ^(cnext.exe), match:title ^(CNEXT)$, tile on"

  # Thunderbird
  # Identity Chooser
  "match:class ^(thunderbird), match:title ^(Identity Chooser)(.*)$, float on"
  "match:class ^(thunderbird), match:title ^(Identity Chooser)(.*)$, center on"
  "match:class ^(thunderbird), match:title ^(Identity Chooser)(.*)$, size 860 620"
  # Calendar entry
  "match:class ^(thunderbird), match:title ^(Edit Item)$, float on"
  "match:class ^(thunderbird), match:title ^(Edit Item)$, center on"
  # Empty title
  "match:class ^(thunderbird), match:title ^$, float on"

  # STM32CubeMX
  "match:class ^(com-st-microxplorer-maingui-STM32CubeMX), match:title ^(win0)$, float on"
  "match:class ^(com-st-microxplorer-maingui-STM32CubeMX), match:title ^(STM32CubeMX)(.*)$, tile on"

  # qFlipper
  "match:class ^(com.flipperdevices.), match:title ^(qFlipper)$, float on"
  "match:class ^(com.flipperdevices.), match:title ^(qFlipper)$, border_size 0"
  "match:class ^(com.flipperdevices.), match:title ^(qFlipper)$, no_blur on"
  "match:class ^(com.flipperdevices.), match:title ^(qFlipper)$, no_shadow on"

  # Discord
  "match:class ^(discord), match:title ^(Discord Updater)$, no_initial_focus on"
  "match:class ^(discord), match:title ^(Discord Updater)$, no_focus on"

  # Ubisoft
  "match:class ^(upc.exe|steam_app_default), match:title ^(Ubisoft Connect)$, tile on"
  # Anno 1800
  "match:class ^(anno1800.exe), match:title ^(Anno 1800)$, tile on"
  "match:class ^(anno1800.exe), match:title ^(Anno 1800)$, fullscreen_state 2 0"
  "match:class ^(anno1800.exe), match:title ^(Anno 1800)$, suppress_event fullscreen"
  "match:class ^(anno1800.exe), match:title ^(Anno 1800)$, suppress_event fullscreen_output"
  "match:class ^(anno1800.exe), match:title ^(Anno 1800)$, suppress_event maximize"
  # "match:class ^(anno1800.exe), match:title ^(Anno 1800)$, fullscreen on"

  # Steam
  "match:class ^(steam), match:title ^(Steam)$, tile on"

  # Thunar
  "match:class ^(thunar), match:title ^(Rename)(.*)$, float on"

  # JabRef
  "match:float true, match:class ^(org.jabref.gui.JabRefGUI), match:title ^$, no_initial_focus on"
  "match:float true, match:class ^(org.jabref.gui.JabRefGUI), match:title ^$, no_focus on"
  "match:float true, match:class ^(org.jabref.gui.JabRefGUI), match:title ^$, no_shadow on"
  "match:float true, match:class ^(org.jabref.gui.JabRefGUI), match:title ^$, no_follow_mouse on"
  "match:float true, match:class ^(org.jabref.gui.JabRefGUI), match:title ^$, no_blur on"
]
