{ pkgs, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "sddm-astronaut-theme";
  version = "48ea0a792711ac0c58cc74f7a03e2e7ba3dc2ac0";

  src = fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = version;
    sha256 = "sha256-kXovz813BS+Mtbk6+nNNdnluwp/7V2e3KJLuIfiWRD0=";
  };

  dontBuild = true;
  dontWrapQtApps = true;

  propagatedBuildInputs = with pkgs; [
    qt6.qtsvg
    qt6.qt5compat
    qt6.qtdeclarative
  ];

  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -aR $src $out/share/sddm/themes/astronaut
  '';

  fixupPhase = ''
    substituteInPlace $out/share/sddm/themes/astronaut/theme.conf \
    	--replace 'Background="background.png"' 'Background="${../../assets/wallpapers/Abstract_1-hue_logo.jpg}"'
  '';
}
