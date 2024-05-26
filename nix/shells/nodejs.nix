{ pkgs, ... }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    nodejs_21
    yarn
    nodePackages.pnpm
  ];
}
