{pkgs ? import <nixpkgs> {}, ...}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    cmake
    ninja
    gcc
    clang-tools
  ];

  shellHook = ''
    unset SOURCE_DATE_EPOCH
  '';
}
