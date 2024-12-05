{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  appimageTools,
}: let
  name = "eLamX2";
  pname = "elamx2";
  version = "2.7.1";

  src = fetchurl {
    url = "https://github.com/AndiMb/eLamX2/releases/download/v${version}/eLamX2-x86_64.AppImage";
    hash = "sha256-2e8QHqIxIZdAl8FYzkpssQdxXCd85jD8QInhwMGaqu8=";
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
      description = "eLamX² is an OpenSource, Java-written composite calculator, which is being developed at Technische Universität Dresden, Institute of Aerospace Engineering, Chair of Aircraft Engineering. Calculations are based on the classical laminated plate theory.";
      homepage = "http://www.elamx.de/";
      license = licenses.gpl3;
      changelog = "https://github.com/AndiMb/eLamX2/releases/tag/v${version}";
      maintainers = with maintainers; [flo2410];
      platforms = platforms.linux;
    };
  }
