{
  stdenv,
  pkgs,
  lib,
  fetchFromGitHub,
  fetchPypi,
}: let
  name = "kel-gui";
  version = "0.2.0";

  pglive = pkgs.python312Packages.buildPythonPackage rec {
    pname = "pglive";
    version = "0.7.5";
    format = "pyproject";

    nativeBuildInputs = with pkgs.python312Packages; [
      poetry-core
      numpy
      pyqtgraph
    ];

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-wrNQaQWp9WX1aiyH0jEMKHrHvOqALgRIO2aWBjfJUbQ=";
    };
  };

  py-kelctl = pkgs.python312Packages.buildPythonPackage rec {
    pname = "py_kelctl";
    version = "0.3.2";
    format = "pyproject";

    nativeBuildInputs = with pkgs; [
      python312Packages.setuptools
      python312Packages.aenum
    ];

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-7CVBMs1C9CcF84OlCSeP0aU0whzRiAdjeKgrD1G8lF4=";
    };
  };
in
  pkgs.python312Packages.buildPythonPackage rec {
    inherit name version;

    format = "pyproject";

    src = fetchFromGitHub {
      owner = "vorbeiei";
      repo = "kelgui";
      rev = "v${version}";
      sha256 = "sha256-TSSHvbREowaXtmvqHbN1Ssc1RjRJped2bLooStfsNww=";
    };

    nativeBuildInputs =
      (with pkgs; [libz])
      ++ (with pkgs.python312Packages; [
        numpy
        pyside6
        pyserial
        pyqtgraph
        aenum
      ])
      ++ [
        pglive
        py-kelctl

        pyinstaller
      ];

    buildPhase = ''
      python -m PyInstaller kelgui.spec
    '';

    installPhase = ''
      ls
      exit 0
      # install -m 444 -D $src -t $out/bin/
    '';
  }
