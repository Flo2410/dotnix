{ stdenvNoCC, lib, fetchzip }:


stdenvNoCC.mkDerivation rec  {
  pname = "breezex-cursor";
  version = "2.0.1";

  src = fetchzip {
    url = "https://github.com/ful1e5/BreezeX_Cursor/releases/download/v${version}/BreezeX.tar.xz";
    hash = "sha256-kq3Amh40QzLnLBzIC3kVMCtsB1ydUahnuY+Jounay4E=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/share/icons/
    cp -r $src/* $out/share/icons
  '';

  meta = with lib; {
    homepage = "https://github.com/ful1e5/BreezeX_Cursor";
    description = "Extended KDE cursor.";
    platforms = platforms.linux;
    maintainers = with maintainers; [ flo2410 ];
    changelog = "https://github.com/ful1e5/BreezeX_Cursor/releases/tag/v${version}";
  };
}


