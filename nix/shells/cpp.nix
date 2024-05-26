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

  shellHook = with pkgs.vscode-marketplace; ''
    unset SOURCE_DATE_EPOCH

    function add-extension {
      ln -sf $1/share/vscode/extensions/* ./.vscode/extensions/
    }

    rm -f ./.vscode/extensions/*

    add-extension ${ms-vscode.cmake-tools}
    add-extension ${ms-vscode.cpptools}
    add-extension ${ms-vscode.makefile-tools}
    add-extension ${bmd.stm32-for-vscode}
  '';
}
