{pkgs}: let
  ltex-vsxi = let
    name = "vscode-ltex-plus";
  in
    pkgs.vscode-utils.buildVscodeMarketplaceExtension rec {
      version = "15.3.0";

      mktplcRef = {
        inherit version name;
        publisher = "ltex-plus";
      };
      vsix = builtins.fetchurl {
        url = "https://github.com/ltex-plus/vscode-ltex-plus/releases/download/${version}/${name}-${version}-offline-linux-x64.vsix";
        sha256 = "sha256:1wdlvbjl97sjqr9spqndc4iva2mmbrf7ajbm4hnxcc8mw3wp5jjy";
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
    takumii.markdowntable
    taniarascia.new-moon-vscode
    neptunedesign.vs-sequential-number
    github.copilot
    github.copilot-chat
    denoland.vscode-deno
    heybourn.headwind

    # Themes
    sdras.night-owl
    catppuccin.catppuccin-vsc-icons
    (pkgs.catppuccin-vsc.override {
      accent = "sapphire";
      boldKeywords = true;
      italicComments = true;
      italicKeywords = true;
      extraBordersEnabled = false;
      workbenchMode = "default";
      bracketMode = "rainbow";
      colorOverrides = {};
      customUIColors = {};
    })

    pkgs.vscode-extensions.ms-vscode-remote.remote-containers
    pkgs.vscode-extensions.ms-vscode-remote.remote-ssh
    pkgs.vscode-extensions.ms-vscode.hexeditor

    james-yu.latex-workshop
    ltex-vsxi

    # TODO: The following should be moved into the coresponding dev shells.

    kamadorueda.alejandra
    astro-build.astro-vscode
    # bbenoist.qml
    andreoneti.qml-formatter
    bmd.stm32-for-vscode
    bourhaouta.tailwindshades
    bradlc.vscode-tailwindcss
    christian-kohler.npm-intellisense
    csstools.postcss
    mrmlnc.vscode-scss
    # cweijan.dbclient-jdbc
    # cweijan.vscode-mysql-client2
    # dan-c-underwood.arm
    dbaeumer.vscode-eslint
    bitwisecook.tcl
    # dotjoshjohnson.xml
    dsznajder.es7-react-js-snippets
    # espressif.esp-idf-extension
    # felipe.nasc-touchbar
    # github.vscode-github-actions
    # ijs.reactnextjssnippets
    # lokalise.i18n-ally
    marp-team.marp-vscode
    marus25.cortex-debug # Required by stm32-for-vscode
    mcu-debug.debug-tracker-vscode # Required by cortex-debug
    mcu-debug.memory-view # Required by cortex-debug
    mcu-debug.peripheral-viewer # Required by cortex-debug
    mcu-debug.rtos-views # Required by cortex-debug
    mechatroner.rainbow-csv
    # mikestead.dotenv
    # mongodb.mongodb-vscode
    # ms-azuretools.vscode-docker
    # ms-ceintl.vscode-language-pack-de
    # ms-iot.vscode-ros
    ms-python.autopep8
    # ms-python.debugpy
    # ms-python.isort
    ms-python.python
    # ms-python.vscode-pylance
    # ms-toolsai.jupyter
    # ms-toolsai.jupyter-keymap
    # ms-toolsai.jupyter-renderers
    # ms-toolsai.vscode-jupyter-cell-tags
    # ms-toolsai.vscode-jupyter-slideshow
    # ms-vscode-remote.remote-wsl
    ms-vscode.cmake-tools
    pkgs.vscode-extensions.ms-vscode.cpptools
    ms-vscode.makefile-tools
    # ms-vscode.vscode-embedded-tools
    # nonanonno.vscode-ros2
    # pflannery.vscode-versionlens
    # platformio.platformio-ide
    # pulkitgangwar.nextjs-snippets
    # quicktype.quicktype
    # smilerobotics.urdf
    vue.volar
    rust-lang.rust-analyzer
    tauri-apps.tauri-vscode
    # trond-snekvik.gnu-mapfiles
    # twxs.cmake
    unifiedjs.vscode-mdx
    # vaisakh96.pythonic-snippets
    # # vscodevim.vim
    # # xabikos.javascriptsnippets
  ]
