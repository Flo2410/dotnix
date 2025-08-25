{
  lib,
  buildNpmPackage,
  makeDesktopItem,
  fetchFromGitHub,
  electron,
  copyDesktopItems,
}: let
  description = "Desktop application (Windows / macOS / Linux) for Home Assistant built with Electron";
in
  buildNpmPackage rec {
    pname = "homeassistant-desktop";
    version = "1.6.7";

    src = fetchFromGitHub {
      owner = "DustyArmstrong";
      repo = pname;
      rev = "${version}";
      hash = "sha256-nkfqhkDEkZluJ/KTHnTTKubvrngqcgJDRodb71S/EqY=";
    };

    npmDepsHash = "sha256-lqZMw74ozi4jJkyOYPodOHx3zgMsfWCguAHUP960egM=";

    nativeBuildInputs = [
      electron
      copyDesktopItems
    ];

    makeCacheWritable = true;
    dontNpmBuild = true;

    env = {
      ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
    };

    postInstall = ''
      makeWrapper ${electron}/bin/electron $out/bin/${pname} \
        --add-flags $out/lib/node_modules/${pname}/app.js

      install -D build/icon.png $out/share/icons/${pname}.png
    '';

    desktopItems = [
      (makeDesktopItem {
        name = pname;
        exec = pname;
        icon = pname;
        desktopName = "Home Assistant";
        comment = description;
      })
    ];

    meta = with lib; {
      homepage = "https://github.com/DustyArmstrong/homeassistant-desktop";
      description = description;
      platforms = platforms.linux;
      changelog = "https://github.com/DustyArmstrong/homeassistant-desktop/releases/tag/${version}";
      license = licenses.asl20;
    };
  }
