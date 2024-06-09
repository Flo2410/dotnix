{ stdenv, pkgs, lib, fetchurl, makeWrapper, makeDesktopItem, copyDesktopItems }:

let
  pname = "olauncher";
  version = "1.7.3_01";
in
stdenv.mkDerivation rec {
  inherit version pname;

  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/v${version}/${pname}-${version}-redist.jar";
    sha256 = "sha256-4zU8ZU8BBGryYlWa/xvin3YRt+G4rv0tX7WtGAH/xAs=";
  };

  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin/
    makeWrapper ${pkgs.jre}/bin/java $out/bin/${pname} \
      --add-flags "-jar ${src}"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = "";
      desktopName = "Minecraft OLauncher";
    })
  ];


  meta = with lib; {
    description = "A modified version of the old Minecraft Launcher supporting Microsoft authentication and more.";
    homepage = "https://github.com/olauncher/olauncher";
    # license = licenses.cc-by-nd-40;
    changelog = "https://github.com/olauncher/olauncher/releases/tag/v${version}";
    maintainers = with maintainers; [ flo2410 ];
    platforms = platforms.linux;
  };
}
 