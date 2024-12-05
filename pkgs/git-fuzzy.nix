{
  stdenv,
  lib,
  fetchFromGitHub,
}: let
  name = "git-fuzzy";
in
  stdenv.mkDerivation {
    pname = name;
    version = "c3e5a63";

    src = fetchFromGitHub {
      owner = "bigH";
      repo = name;
      rev = "c3e5a63d6d44d7e38e78dba88b712bfdae0036c2";
      sha256 = "sha256-tkNxEvCBnkg5OISb+ZrmbTBgy/zEsCUfHD3U35EzI+Q=";
    };

    installPhase = ''
      runHook preInstall
      cp -r . $out/
      runHook postInstall
    '';
  }
