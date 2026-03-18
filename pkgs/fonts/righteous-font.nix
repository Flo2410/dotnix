{
  stdenvNoCC,
  lib,
  fetchurl,
}:
stdenvNoCC.mkDerivation {
  pname = "righteous-font";
  version = "2";
  src = fetchurl {
    url = "https://raw.githubusercontent.com/google/fonts/refs/heads/main/ofl/righteous/Righteous-Regular.ttf";
    sha256 = "sha256-L/s/5cJ9fmVxIQuABEjE4jTmUbRsa0QmwbtWflNBNIo=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/
    cp -r $src $out/share/fonts/truetype/Righteous-Regular.ttf
  '';

  meta = with lib; {
    description = "Righteous font";
    homepage = "https://fonts.google.com/specimen/Righteous";
    platforms = platforms.all;
  };
}
