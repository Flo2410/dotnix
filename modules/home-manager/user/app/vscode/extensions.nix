{ pkgs }:

let
  ltex-vsxi = pkgs.vscode-utils.buildVscodeMarketplaceExtension rec {
    version = "${pkgs.vscode-marketplace.neo-ltex.ltex.version}";
    mktplcRef = {
      inherit version;
      name = "ltex";
      publisher = "neo-ltex";
    };
    vsix = builtins.fetchurl {
      url = "https://github.com/neo-ltex/vscode-ltex/releases/download/${version}/ltex-${version}-offline-linux-x64.vsix";
      sha256 = "sha256:0wlcndwax4d68b29k2kmagv3vm01ill4dix9d8cljdnwfvzaapr8";
    };

    unpackPhase = ''
      unzip ${vsix}
    '';
  };

in
with pkgs.vscode-marketplace; [
  aaron-bond.better-comments
  albert.tabout
  antiantisepticeye.vscode-color-picker
  codezombiech.gitignore
  davidanson.vscode-markdownlint
  eamodio.gitlens
  esbenp.prettier-vscode
  formulahendry.auto-rename-tag
  gruntfuggly.todo-tree
  jnoortheen.nix-ide
  jock.svg
  mkhl.direnv
  ms-vscode-remote.remote-ssh-edit
  #ms-vscode.remote-explorer
  naumovs.color-highlight
  pkief.material-icon-theme
  psioniq.psi-header
  sdras.night-owl
  takumii.markdowntable
  taniarascia.new-moon-vscode

  pkgs.vscode-extensions.ms-vscode-remote.remote-containers
  pkgs.vscode-extensions.ms-vscode-remote.remote-ssh
  pkgs.vscode-extensions.ms-vscode.hexeditor

  james-yu.latex-workshop
  ltex-vsxi

  # TODO: The following should be moved into the coresponding dev shells.

  # astro-build.astro-vscode
  # bbenoist.qml
  # bmd.stm32-for-vscode
  # bourhaouta.tailwindshades
  # bradlc.vscode-tailwindcss
  # christian-kohler.npm-intellisense
  # csstools.postcss
  # cweijan.dbclient-jdbc
  # cweijan.vscode-mysql-client2
  # dan-c-underwood.arm
  # dbaeumer.vscode-eslint
  # dotjoshjohnson.xml
  # dsznajder.es7-react-js-snippets
  # espressif.esp-idf-extension
  # felipe.nasc-touchbar
  # github.vscode-github-actions
  # ijs.reactnextjssnippets
  # lokalise.i18n-ally
  # marus25.cortex-debug
  # mcu-debug.debug-tracker-vscode
  # mcu-debug.memory-view
  # mcu-debug.peripheral-viewer
  # mcu-debug.rtos-views
  # mechatroner.rainbow-csv
  # mikestead.dotenv
  # mongodb.mongodb-vscode
  # ms-azuretools.vscode-docker
  # ms-ceintl.vscode-language-pack-de
  # ms-iot.vscode-ros
  # ms-python.black-formatter
  # ms-python.debugpy
  # ms-python.isort
  # ms-python.python
  # ms-python.vscode-pylance
  # ms-toolsai.jupyter
  # ms-toolsai.jupyter-keymap
  # ms-toolsai.jupyter-renderers
  # ms-toolsai.vscode-jupyter-cell-tags
  # ms-toolsai.vscode-jupyter-slideshow
  # ms-vscode-remote.remote-wsl
  # ms-vscode.cmake-tools
  # ms-vscode.cpptools
  # ms-vscode.makefile-tools
  # ms-vscode.vscode-embedded-tools
  # nonanonno.vscode-ros2
  # pflannery.vscode-versionlens
  # platformio.platformio-ide
  # pulkitgangwar.nextjs-snippets
  # quicktype.quicktype
  # rust-lang.rust-analyzer
  # smilerobotics.urdf
  # tauri-apps.tauri-vscode
  # trond-snekvik.gnu-mapfiles
  # twxs.cmake
  # unifiedjs.vscode-mdx
  # vaisakh96.pythonic-snippets
  # # vscodevim.vim
  # # xabikos.javascriptsnippets

]
