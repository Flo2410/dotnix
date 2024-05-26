{ pkgs, ... }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    nodejs_21
    yarn
    nodePackages.pnpm
  ];

  shellHook = with pkgs.vscode-marketplace; ''
    function add-extension {
      ln -sf $1/share/vscode/extensions/* ./.vscode/extensions/
    }

    rm -f ./.vscode/extensions/*

    add-extension ${astro-build.astro-vscode}
    add-extension ${bourhaouta.tailwindshades}
    add-extension ${bradlc.vscode-tailwindcss}
    add-extension ${christian-kohler.npm-intellisense}
    add-extension ${csstools.postcss}
    add-extension ${dbaeumer.vscode-eslint}
    add-extension ${unifiedjs.vscode-mdx}
  '';
}
