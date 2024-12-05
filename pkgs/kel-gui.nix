{
  pkgs,
  lib,
  fetchFromGitHub,
}: let
  name = "kel-gui";
  version = "0.2.0";
in
  lib.buildPythonPackage rec {
    inherit name version;

    src = fetchFromGitHub {
      owner = "vorbeiei";
      repo = "kelgui";
      rev = "v${version}";
      sha256 = "";
    };

    propagatedBuildInputs = with pkgs.python3Packages; [
      PySide6
      pyserial
      pyqtgraph
      py_kelctl
      pglive
      numpy
      pyinstaller
    ];
  }
