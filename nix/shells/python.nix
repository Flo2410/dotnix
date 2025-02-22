{pkgs ? import <nixpkgs> {}, ...}: let
  python =
    pkgs.python3.withPackages
    (p:
      with p; [
        numpy
        matplotlib
        json5
        requests
        urllib3
        configobj
      ]);
in
  pkgs.mkShellNoCC {
    nativeBuildInputs = [
      python
    ];

    shellHook = ''
      echo `${python}/bin/python --version`
    '';
  }
