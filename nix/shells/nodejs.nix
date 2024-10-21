{ pkgs, ... }:

pkgs.mkShellNoCC {
  nativeBuildInputs = with pkgs; [
    nodejs_22
    bun
    deno
    yarn
    nodePackages.pnpm
  ];
}
