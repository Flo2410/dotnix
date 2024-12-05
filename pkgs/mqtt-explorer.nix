{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  appimageTools,
}: let
  name = "MQTT-Explorer";
  pname = "mqtt-explorer";
  version = "0.3.5";

  src = fetchurl {
    url = "https://github.com/thomasnordquist/MQTT-Explorer/releases/download/v${version}/MQTT-Explorer-${version}.AppImage";
    hash = "sha256-Yfz42+dVIx3xwIOmYltp5e9rYka+KskvQuxJVVBgbg4=";
  };

  appimageContents = appimageTools.extractType2 {inherit name src;};
in
  appimageTools.wrapType2 rec {
    inherit name src;

    extraInstallCommands = ''
      mv $out/bin/${name} $out/bin/${pname}

      install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop

      install -m 444 -D ${appimageContents}/${pname}.png $out/share/icons/hicolor/512x512/apps/${pname}.png

      substituteInPlace $out/share/applications/${pname}.desktop \
      	--replace 'Exec=AppRun' 'Exec=${pname}'
    '';

    meta = with lib; {
      description = "An all-round MQTT client that provides a structured topic overview";
      homepage = "https://mqtt-explorer.com/";
      # license = licenses.cc-by-nd-40;
      changelog = "https://github.com/thomasnordquist/MQTT-Explorer/releases/tag/v${version}";
      maintainers = with maintainers; [flo2410];
      platforms = platforms.linux;
    };
  }
