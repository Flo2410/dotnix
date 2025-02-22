{pkgs ? import <nixpkgs> {}, ...}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    cmake
    gcc
    gcc-arm-embedded-12
    openocd
    clang-tools
    platformio-core
    platformio
    python3
    avrdude

    pkgsCross.avr.buildPackages.gcc
  ];

  shellHook = ''
  '';
}
