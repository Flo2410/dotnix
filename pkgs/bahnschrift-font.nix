{
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "bahnschrift-font";
  version = "2";
  src = ../assets/fonts/Bahnschrift.ttf;

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/
    cp -r $src $out/share/fonts/truetype/Bahnschrift.ttf
  '';

  meta = with lib; {
    description = "Bahnschrift font";
    homepage = "https://learn.microsoft.com/en-us/typography/font-list/bahnschrift";
    platforms = platforms.all;
  };
}
