{ pkgs, ... }:


pkgs.mkShell rec {
  nativeBuildInputs = with pkgs; [
    pkg-config
    openssl
    cargo
    rustc
    rust-analyzer
    clippy
    rustfmt
    rustPlatform.rustLibSrc
  ];

  RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";

  shellHook = with pkgs.vscode-marketplace; ''
    function add-extension {
      ln -sf $1/share/vscode/extensions/* ./.vscode/extensions/
    }

    rm -f ./.vscode/extensions/*

    add-extension ${tauri-apps.tauri-vscode}
    add-extension ${rust-lang.rust-analyzer}
  '';
}
