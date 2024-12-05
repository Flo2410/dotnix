{
  lib,
  stdenv,
  requireFile,
  pkgs,
  fetchurl,
}: let
  name = "STM32CubeProg";
  pname = "stm32cubeprog";
  version = "2.16.0";

  jdk_fx = pkgs.jdk8;
in
  stdenv.mkDerivation {
    inherit name pname;

    src = requireFile rec {
      name = "en.stm32cubeprg-lin-v${builtins.replaceStrings ["."] ["-"] version}.zip";
      message = ''
        Unfortunately, we cannot download file ${name} automatically.
        Please proceed with the following steps to download and add it to the Nix
        store yourself:
        1. get en.STM32CubeMX_${builtins.replaceStrings ["."] ["-"] version}.zip
        2. add the result to the store: nix-prefetch-url file://\$PWD/${name}
      '';
      sha256 = "0iz5ql69blg47hqwwj4w7jjbxnb7pmiqkbls0qdji2q261hzcqml";
    };

    extra_java = fetchurl {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/AnalyticsPanelsConsoleHelper.java?h=stm32cubeprog";
      sha256 = "sha256-EvP4ozAdb1DAAZX5yFLiX42EEkZ2i/O7/U6R/SBSzm4=";
    };

    nativeBuildInputs = with pkgs; [
      unzip
      p7zip
      makeWrapper
      autoPatchelfHook

      jdk_fx

      libusb
      stdenv.cc.cc.lib
      zlib
      libkrb5
      libGL

      libsForQt5.qt5.qtbase.out
      openssl
      pcsclite.lib

      xorg.libX11
      xorg.libxcb
    ];

    unpackPhase = ''
      runHook preUnpack
      unzip -j $src SetupSTM32CubeProgrammer-${version}.linux SetupSTM32CubeProgrammer-${version}.exe
      runHook postUnpack
    '';

    patchPhase = ''
      runHook prePatch

      cp $extra_java AnalyticsPanelsConsoleHelper.java
      ${jdk_fx}/bin/javac -cp "SetupSTM32CubeProgrammer-${version}.exe" -d . AnalyticsPanelsConsoleHelper.java
      7z a SetupSTM32CubeProgrammer-${version}.exe com/st/CustomPanels/AnalyticsPanelsConsoleHelper.class

      runHook postPatch
    '';

    buildPhase = ''
      runHook preBuild

      ln -s ${jdk_fx} jre

      chmod u+x SetupSTM32CubeProgrammer-${version}.linux

      echo "INSTALL_PATH=./build" > install.options
      mkdir build
      set +e
      echo "\n" | ./SetupSTM32CubeProgrammer-${version}.linux -options-auto install.options
      set -e

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,opt/STM32CubeProg}
      cp -a ./build/. $out/opt/STM32CubeProg
      rm -r $out/opt/STM32CubeProg/updater
      rm $out/opt/STM32CubeProg/bin/libssl.so

      chmod u+x $out/opt/STM32CubeProg/bin/STM32_Programmer_CLI
      chmod u+x $out/opt/STM32CubeProg/bin/STM32CubeProgrammerLauncher

      makeWrapper ${jdk_fx}/bin/java $out/bin/${pname} \
        --add-flags "-Djdk.gtk.version=3 -jar $out/opt/STM32CubeProg/bin/STM32CubeProgrammerLauncher"

      runHook postInstall
    '';

    preFixup = ''
      addAutoPatchelfSearchPath $out/opt/STM32CubeProg/lib
    '';

    meta = with lib; {
      maintainers = with maintainers; [flo2410];
      platforms = platforms.linux;
    };
  }
