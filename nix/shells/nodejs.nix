{ pkgs, ... }:

pkgs.mkShellNoCC {
  nativeBuildInputs = with pkgs; [
    nodejs_21
    yarn
    nodePackages.pnpm
  ];
}
