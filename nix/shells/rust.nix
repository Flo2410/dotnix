{pkgs ? import <nixpkgs> {}, ...}:
pkgs.unstable.mkShell {
  nativeBuildInputs = with pkgs.unstable; [
    pkg-config
    openssl
    cargo
    rustc
    rust-analyzer
    clippy
    rustfmt
    rustPlatform.rustLibSrc
  ];

  RUST_SRC_PATH = "${pkgs.unstable.rustPlatform.rustLibSrc}";
}
