{ pkgs, config }:

let
  dotfilesDirectory = config.user.home.dotfilesDirectory;
  username = config.user.home.username;
in
{
  # --------------------------------------------------
  # VS Code
  # --------------------------------------------------

  # Workbench Settings
  "workbench.iconTheme" = "material-icon-theme";
  "workbench.colorTheme" = "Night Owl";
  "workbench.preferredDarkColorTheme" = "Night Owl";
  "workbench.preferredLightColorTheme" = "Night Owl Light";
  "workbench.startupEditor" = "none";
  "workbench.colorCustomizations" = {
    "[Night Owl]" = {
      "editorInlayHint.foreground" = "#f0f0f093";
      "editorInlayHint.background" = "#082e4968";
    };
  };

  # Editor Settings
  "editor.fontFamily" = "Fira Code";
  "editor.inlayHints.fontFamily" = "Fira Code";
  "editor.fontSize" = 13;
  "editor.fontLigatures" = true;
  "editor.bracketPairColorization.enabled" = true;
  "editor.guides.bracketPairs" = "active";
  "editor.renderWhitespace" = "all";
  "editor.formatOnSave" = true;
  "editor.linkedEditing" = true;
  "editor.largeFileOptimizations" = false;
  "editor.detectIndentation" = false;
  "editor.tabSize" = 2;
  "editor.suggestSelection" = "first";
  "editor.defaultFormatter" = "esbenp.prettier-vscode";
  "editor.wordBasedSuggestions" = "off";
  "editor.minimap.autohide" = true;
  "editor.minimap.renderCharacters" = false;
  "editor.minimap.scale" = 2;
  "editor.wordWrap" = "off";

  # Terminal
  "terminal.integrated.fontFamily" = "Fira Code";
  "terminal.integrated.defaultProfile.linux" = "zsh";
  "terminal.integrated.inheritEnv" = false;
  "terminal.integrated.cursorStyle" = "line";
  "terminal.integrated.cursorBlinking" = true;
  "terminal.integrated.cursorWidth" = 2;

  # Explorer
  "explorer.confirmDelete" = false;
  "explorer.compactFolders" = false;
  "explorer.confirmDragAndDrop" = false;
  "explorer.confirmPasteNative" = false;

  # telemetry
  "telemetry.telemetryLevel" = "off";

  # debug
  "debug.toolBarLocation" = "docked";

  # do not check for updates.
  "update.mode" = "none";
  "extensions.autoCheckUpdates" = false;
  "extensions.autoUpdate" = false;

  # files
  "files.exclude" = {
    "**/.git" = false;
  };

  # autopep8
  "autopep8.args" = [
    "--indent-size=2"
    "--ignore=E121"
  ];

  # --------------------------------------------------
  # Extenstion specific
  # --------------------------------------------------

  # Git
  "git.autofetch" = true;
  "git.confirmSync" = false;
  "git.enableCommitSigning" = true;
  "git.enableSmartCommit" = false;
  "git.suggestSmartCommit" = false;

  # Gitlense
  "gitlens.graph.layout" = "editor";

  # CMake
  "cmake.showOptionsMovedNotification" = false;

  # ltex
  # "ltex.ltex-ls.path" = "${pkgs.ltex-ls}";
  "ltex.java.path" = "${pkgs.temurin-bin-20}";
  # "ltex.ltex-ls.logLevel" = "finest";
  # "ltex.trace.server" = "verbose";
  "ltex.language" = "de-AT";
  "ltex.additionalRules.motherTongue" = "de-AT";
  "ltex.additionalRules.enablePickyRules" = true;
  "ltex.configurationTarget" = {
    "dictionary" = "workspaceFolder";
    "disabledRules" = "workspaceFolder";
    "hiddenFalsePositives" = "workspaceFolder";
  };
  "ltex.completionEnabled" = true;
  "ltex.disabledRules" = {
    "de-AT" = [ "WHITESPACE_RULE" ];
  };

  # stm32 for vscode
  "stm32-for-vscode.openOCDPath" = "${pkgs.openocd}/bin/openocd";
  "stm32-for-vscode.makePath" = "${pkgs.gnumake}/bin/make";
  "stm32-for-vscode.armToolchainPath" = "${pkgs.gcc-arm-embedded-12}/bin";

  # platformio
  "platformio-ide.useBuiltinPython" = false;
  "platformio-ide.useBuiltinPIOCore" = false;

  # prettier
  "prettier.printWidth" = 100;
  "prettier.requireConfig" = true;

  # tailwindCSS
  "tailwindCSS.experimental.classRegex" = [
    [
      "clsx\\(([^)]*)\\)"
      "(?:'|\"|`)([^']*)(?:'|\"|`)"
    ]
  ];
  "tailwindCSS.includeLanguages" = {
    "plaintext" = "html";
  };
  "tailwindCSS.emmetCompletions" = true;

  # psi-header
  "psi-header.config" = {
    "forceToTop" = true;
    "blankLinesAfter" = 1;
    "spacesBetweenYears" = false;
    "enforceHeader" = true;
  };

  "psi-header.lang-config" = [
    {
      "language" = "python";
      "begin" = "";
      "prefix" = "# ";
      "end" = "";
    }
  ];
  "psi-header.templates" = [
    {
      "language" = "*";
      "template" = [
        "----------------------------------------------------------------------------------------------------------------------------------------------"
        "File: <<filename>>"
        "Created Date: <<filecreated('dddd, MMMM Do YYYY, h:mm:ss a')>>"
        "Author: <<author>>"
        "Description: "
        "----------------------------------------------------------------------------------------------------------------------------------------------"
      ];
      "changeLogCaption" = "HISTORY=";
      "changeLogHeaderLineCount" = 2;
      "changeLogEntryTemplate" = [ "<<dateformat('YYYY-MM-DD')>>\t<<initials>>\t" ];
    }
  ];

  # hexeditor
  "hexeditor.columnWidth" = 16;
  "hexeditor.showDecodedText" = true;
  "hexeditor.defaultEndianness" = "little";
  "hexeditor.inspectorType" = "aside";

  # remote
  "remote.autoForwardPortsSource" = "hybrid";

  # nix
  "nix.enableLanguageServer" = true;
  "nix.serverPath" = "nixd";

  "nix.serverSettings" = {
    # settings for 'nixd' LSP
    "nixd" = {
      "nixpkgs" = {
        # For flake.
        "expr" = "import (builtins.getFlake \"${dotfilesDirectory}\").inputs.nixpkgs { }";

        # This expression will be interpreted as "nixpkgs" toplevel
        # Nixd provides package, lib completion/information from it.
        #/
        # Resouces Usage: Entries are lazily evaluated, entire nixpkgs takes 200~300MB for just "names".
        #/                Package documentation, versions, are evaluated by-need.
        # "expr" = "import <nixpkgs> { }";
      };
      "options" = {
        # By default, this entriy will be read from `import <nixpkgs> { }`
        # You can write arbitary nix expression here, to produce valid "options" declaration result.
        # Tip: for flake-based configuration, utilize `builtins.getFlake`
        "nixos" = {
          "expr" = "(builtins.getFlake \"${dotfilesDirectory}\").nixosConfigurations.\"fwf\".options";
        };
        "home-manager" = {
          "expr" = "(builtins.getFlake \"${dotfilesDirectory}\").homeConfigurations.\"${username}\".options";
        };
      };
    };
  };

  # --------------------------------------------------
  # Language specific
  # --------------------------------------------------

  "[markdown]" = {
    "editor.defaultFormatter" = "DavidAnson.vscode-markdownlint";
  };

  "[latex]" = {
    "editor.defaultFormatter" = "James-Yu.latex-workshop";
  };

  "[bibtex]" = {
    "editor.defaultFormatter" = "James-Yu.latex-workshop";
  };

  "[c]" = {
    "editor.defaultFormatter" = "ms-vscode.cpptools";
  };

  "[cpp]" = {
    "editor.defaultFormatter" = "ms-vscode.cpptools";
  };

  "[nix]" = {
    "editor.defaultFormatter" = "jnoortheen.nix-ide";
  };

  "[rust]" = {
    "editor.defaultFormatter" = "rust-lang.rust-analyzer";
  };

  "[xml]" = {
    "editor.defaultFormatter" = "DotJoshJohnson.xml";
  };

  "[html]" = {
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
  };

  "[json]" = {
    "editor.defaultFormatter" = "vscode.json-language-features";
  };

  "[jsonc]" = {
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
  };

  "[typescriptreact]" = {
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
  };

  "[typescript]" = {
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
  };

  "[javascriptreact]" = {
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
  };

  "[javascript]" = {
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
  };

  "[python]" = {
    "editor.defaultFormatter" = "ms-python.autopep8";
    "editor.insertSpaces" = true;
    "editor.tabSize" = 2;
  };

  "[tex]" = {
    "editor.defaultFormatter" = "James-Yu.latex-workshop";
  };

  "[qml]" = {
    "editor.defaultFormatter" = "AndreOneti.qml-formatter";
  };
}
