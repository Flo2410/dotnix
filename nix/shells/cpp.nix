{ pkgs, ... }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    cmake
    ninja
    gcc
    gcc-arm-embedded-12
    openocd
    clang-tools
    dfu-util
  ];

  shellHook = ''
    unset SOURCE_DATE_EPOCH
  '';
}
