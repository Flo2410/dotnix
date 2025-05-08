{pkgs ? import <nixpkgs> {}, ...}:
pkgs.mkShell {
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
  RUST_BACKTRACE = 1;

  shellHook = ''
    # Avoid polluting home dir with local project stuff.
    export RUSTUP_HOME=$PWD/.rustup-home
    export CARGO_HOME=$PWD/.cargo-home


    # Load environment variables from .env file
    # set -a # automatically export all variables
    # source .env
    # set +a
  '';
}
