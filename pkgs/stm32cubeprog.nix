{ lib, stdenv, requireFile, pkgs, fetchurl }:

let

  name = "STM32CubeProg";
  pname = "stm32cubeprog";
  version = "2.16.0";

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
      5. add the result to the store: nix-prefetch-url file://\$PWD/${name}
    '';
    sha256 = "0iz5ql69blg47hqwwj4w7jjbxnb7pmiqkbls0qdji2q261hzcqml";
  };

  extra_java = fetchurl {
    url = "https://aur.archlinux.org/cgit/aur.git/plain/AnalyticsPanelsConsoleHelper.java?h=stm32cubeprog";
    sha256 = "sha256-EvP4ozAdb1DAAZX5yFLiX42EEkZ2i/O7/U6R/SBSzm4=";
  };


  nativeBuildInputs = with pkgs; [
    unzip
    jre
    p7zip
  ];

  unpackPhase = ''
    unzip -j $src SetupSTM32CubeProgrammer-${version}.linux SetupSTM32CubeProgrammer-${version}.exe
  '';

  patchPhase = ''
    cp $extra_java AnalyticsPanelsConsoleHelper.java
    ${pkgs.jre}/bin/javac -cp "SetupSTM32CubeProgrammer-${version}.exe" -d . AnalyticsPanelsConsoleHelper.java
    7z a SetupSTM32CubeProgrammer-${version}.exe com/st/CustomPanels/AnalyticsPanelsConsoleHelper.class
  '';

  buildPhase = ''
    mkdir -p $out/{bin,opt/STM32CubeProg}
    ln -s ${pkgs.jre} jre
    chmod u+x SetupSTM32CubeProgrammer-${version}.linux
    
    echo "INSTALL_PATH=./build" > install.options
    ./SetupSTM32CubeProgrammer-${version}.linux -options-auto install.options
  '';

  installPhase = ''
    cp ./build $out/opt/STM32CubeProg
  '';

  meta = with lib;
    {
      maintainers = with maintainers; [ flo2410 ];
      platforms = platforms.linux;
    };
}

