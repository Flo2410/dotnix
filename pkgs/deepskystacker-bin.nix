{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeDesktopItem,
  fakeroot,
  libicns,
  qt6,
  xorg,
  exiv2,
  zlib,
  gtk3,
  pango,
  libtiff,
  binutils,
}: let
  libtiff-compat = stdenv.mkDerivation {
    name = "libtiff-compat";
    dontUnpack = true;
    buildInputs = [
      libtiff.out
    ];

    installPhase = ''
      mkdir -p $out/lib
      ln -s ${libtiff.out}/lib/libtiff.so $out/lib/libtiff.so.5
    '';
  };
in
  stdenv.mkDerivation rec {
    pname = "deepskystacker";
    version = "6.1.3";

    src = fetchurl {
      url = "https://github.com/deepskystacker/DSS/releases/download/${version}/DeepSkyStacker-${version}-linux-x64-installer.run";
      hash = "sha256-O4JJw24iQz4zLqR0mGivNGaFUOIN1EA2M1rq7pcKzfo=";
    };

    dontUnpack = true;

    nativeBuildInputs = [
      autoPatchelfHook
      qt6.wrapQtAppsHook
      fakeroot
      libicns
    ];

    buildInputs = [
      qt6.qtbase
      qt6.qtcharts.out
      qt6.qtquick3d.out
      qt6.qtvirtualkeyboard.out
      xorg.xcbutilcursor
      exiv2
      zlib
      gtk3
      pango
      libtiff.out
      libtiff-compat
      binutils
    ];

    buildPhase = ''
      export tmp=$(mktemp -d)

      cp $src $tmp/dss.run
      chmod 755 $tmp/dss.run
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $tmp/dss.run

      fakeroot $tmp/dss.run --unattendedmodeui none --mode unattended --prefix $tmp/DeepSkyStacker || true
    '';

    installPhase = ''
      mkdir -p $out/bin $out/opt $out/lib/plugins $out/share/icons/ $out/share/mime/packages/

      install -m 555 -D $tmp/DeepSkyStacker/DeepSkyStacker $out/opt/DeepSkyStacker-unwrapped
      install -m 555 -D $tmp/DeepSkyStacker/DeepSkyStackerLive $out/opt/DeepSkyStackerLive-unwrapped
      install -m 555 -D $tmp/DeepSkyStacker/DeepSkyStackerCL $out/bin/DeepSkyStackerCL

      cp -r $tmp/DeepSkyStacker/plugins/*  $out/lib/plugins/

      install -m 444 -D $tmp/DeepSkyStacker/*.png $out/share/icons/
      install -m 444 -D $tmp/DeepSkyStacker/com.github.deepskystacker-x-text-dssfilelist.xml $out/share/mime/packages/
      install -m 444 -D $desktopItemDSS/share/applications/* -t $out/share/applications
      install -m 444 -D $desktopItemDSSLive/share/applications/* -t $out/share/applications

      mkdir -p $tmp/icons
      icns2png -x -o $tmp/icons $tmp/DeepSkyStacker/DeepSkyStacker.icns
      icns2png -x -o $tmp/icons $tmp/DeepSkyStacker/DSSLive.icns

      mkdir -p $out/share/icons/hicolor/{1024x1024,512x512,256x256,128x128,64x64,32x32}/apps/
      cp $tmp/icons/*1024x1024*.png $out/share/icons/hicolor/1024x1024/apps/
      cp $tmp/icons/*512x512*.png $out/share/icons/hicolor/512x512/apps/
      cp $tmp/icons/*256x256*.png $out/share/icons/hicolor/256x256/apps/
      cp $tmp/icons/*128x128*.png $out/share/icons/hicolor/128x128/apps/
      cp $tmp/icons/*64x64*.png $out/share/icons/hicolor/64x64/apps/
      cp $tmp/icons/*32x32*.png $out/share/icons/hicolor/32x32/apps/

      find $out/share/icons/hicolor -name "*.png" | while read f; do mv "$f" "$(echo "$f" | sed 's/_[0-9]\+x[0-9]\+\(x[0-9]\+\)\?\.png/.png/')"; done

      makeWrapper $out/opt/DeepSkyStacker-unwrapped $out/bin/DeepSkyStacker \
        --set QT_QPA_PLATFORM_PLUGIN_PATH "${qt6.qtbase}/lib/qt-${qt6.qtbase.version}/plugins/platforms" \
        --set LD_LIBRARY_PATH "$out/opt/DeepSkyStacker-unwrapped:${lib.makeLibraryPath buildInputs}"

        makeWrapper $out/opt/DeepSkyStackerLive-unwrapped $out/bin/DeepSkyStackerLive \
          --set QT_QPA_PLATFORM_PLUGIN_PATH "${qt6.qtbase}/lib/qt-${qt6.qtbase.version}/plugins/platforms" \
          --set LD_LIBRARY_PATH "$out/opt/DeepSkyStackerLive-unwrapped:${lib.makeLibraryPath buildInputs}"
    '';

    desktopItemDSS = makeDesktopItem {
      name = "DeepSkyStacker";
      desktopName = "DeepSkyStacker";
      genericName = "The preferred application for stacking astronomical images";
      exec = "DeepSkyStacker";
      terminal = false;
      type = "Application";
      icon = "DeepSkyStacker";
      mimeTypes = ["text/dssfilelist"];
      categories = ["Astronomy" "Science"];
    };

    desktopItemDSSLive = makeDesktopItem {
      name = "DeepSkyStackerLive";
      desktopName = "DeepSkyStackerLive";
      genericName = "The preferred application for live stacking astronomical images";
      exec = "DeepSkyStackerLive";
      terminal = false;
      type = "Application";
      icon = "DSSLive";
      categories = ["Astronomy" "Science"];
    };

    meta = with lib; {
      description = "Stacking software for deep sky astrophotography";
      homepage = "https://github.com/deepskystacker/DSS";
      changelog = "https://github.com/deepskystacker/DSS/releases/tag/${version}";
      license = licenses.bsd3;
      maintainers = [];
      platforms = platforms.linux;
    };
  }
