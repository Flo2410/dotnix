{
  pkgs,
  config,
}: let
  dotfilesDirectory = config.user.home.dotfilesDirectory;
  username = config.user.home.username;
in {
  # --------------------------------------------------
  # VS Code
  # --------------------------------------------------

  # Workbench Settings
  "workbench.iconTheme" = "catppuccin-mocha";
  "workbench.colorTheme" = "Catppuccin Mocha";
  "workbench.preferredDarkColorTheme" = "Catppuccin Mocha";
  "workbench.preferredLightColorTheme" = "Night Owl Light";
  "workbench.startupEditor" = "none";
  "workbench.colorCustomizations" = {
    "[Night Owl]" = {
      "editorInlayHint.foreground" = "#f0f0f093";
      "editorInlayHint.background" = "#082e4968";
    };
  };
  "workbench.editor.empty.hint" = "hidden";
  "workbench.editorAssociations" = {
    "*.bin" = "hexEditor.hexedit";
  };
  "workbench.secondarySideBar.defaultVisibility" = "hidden";

  # Window Settings
  "window.titleBarStyle" = "custom";
  "window.experimentalControlOverlay" = true;

  # Editor Settings
  "editor.fontFamily" = "${config.stylix.fonts.monospace.name}";
  "editor.inlayHints.enabled" = "on";
  "editor.inlayHints.fontFamily" = "${config.stylix.fonts.monospace.name}";
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
  "editor.minimap.autohide" = "mouseover";
  "editor.minimap.renderCharacters" = false;
  "editor.minimap.scale" = 2;
  "editor.wordWrap" = "off";
  "editor.selectionClipboard" = false;

  # Diff Editor
  "diffEditor.ignoreTrimWhitespace" = false;

  # Terminal
  "terminal.integrated.fontFamily" = "${config.stylix.fonts.monospace.name}";
  "terminal.integrated.defaultProfile.linux" = "nu";
  "terminal.integrated.inheritEnv" = false;
  "terminal.integrated.cursorStyle" = "line";
  "terminal.integrated.cursorBlinking" = true;
  "terminal.integrated.cursorWidth" = 2;
  "terminal.integrated.initialHint" = false;

  # Explorer
  "explorer.confirmDelete" = false;
  "explorer.compactFolders" = false;
  "explorer.confirmDragAndDrop" = false;
  "explorer.confirmPasteNative" = false;
  "explorer.autoOpenDroppedFile" = false;

  # telemetry
  "telemetry.telemetryLevel" = "off";

  # debug
  "debug.toolBarLocation" = "commandCenter";
  "debug.showVariableTypes" = true;

  # do not check for updates.
  "update.mode" = "none";
  "extensions.autoCheckUpdates" = false;
  "extensions.autoUpdate" = false;

  # files
  "files.exclude" = {
    "**/.git" = false;
    "~/.cache" = true;
  };

  # search
  "search.exclude" = {
    "**/.git" = true;
    "**/.direnv" = true;
    "~/.cache" = true;
  };

  # autopep8
  "autopep8.args" = [
    "--indent-size=2"
    "--ignore=E121"
  ];

  # keybard
  "keyboard.dispatch" = "keyCode"; # This is nedded for the vim extension to recognize the remapped caps lock key as escape.

  # Source control
  "scm.defaultViewMode" = "list";

  # --------------------------------------------------
  # Extenstion specific
  # --------------------------------------------------

  # Git
  "git.autofetch" = true;
  "git.confirmSync" = false;
  "git.enableCommitSigning" = true;
  "git.enableSmartCommit" = false;
  "git.suggestSmartCommit" = false;

  # Git Blame
  "git.blame.editorDecoration.enabled" = true;
  "git.blame.editorDecoration.template" = "\${subject} // \${authorName} (\${authorDateAgo})";

  # Gitlense
  "gitlens.graph.layout" = "editor";

  # CMake
  "cmake.showOptionsMovedNotification" = false;

  # ltex
  "ltex.ltex-ls.path" = "${pkgs.ltex-ls-plus}";
  "ltex.java.path" = "${pkgs.temurin-bin-21}";
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
    "de-AT" = ["WHITESPACE_RULE"];
  };

  # latex workshop
  "latex-workshop.formatting.latex" = "latexindent";

  # stm32 for vscode
  "stm32-for-vscode.openOCDPath" = "${pkgs.openocd}/bin/openocd";
  "stm32-for-vscode.makePath" = "${pkgs.gnumake}/bin/make";
  "stm32-for-vscode.armToolchainPath" = "${pkgs.gcc-arm-embedded-13}/bin";

  # platformio
  "platformio-ide.useBuiltinPython" = false;
  "platformio-ide.useBuiltinPIOCore" = false;

  # prettier
  "prettier.printWidth" = 100;
  "prettier.tabWidth" = 2;
  "prettier.requireConfig" = false;

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
      "changeLogEntryTemplate" = ["<<dateformat('YYYY-MM-DD')>>\t<<initials>>\t"];
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

  # naumovs.color-highlight
  "color-highlight.languages" = [
    "*"
    "!c"
    "!cpp"
    "!rust"
    "!nix"
    "!python"
  ];

  # Javascript
  "javascript.inlayHints.enumMemberValues.enabled" = true;
  "javascript.inlayHints.functionLikeReturnTypes.enabled" = true;
  "javascript.inlayHints.parameterNames.enabled" = "all";
  "javascript.inlayHints.variableTypes.enabled" = true;
  "javascript.inlayHints.variableTypes.suppressWhenTypeMatchesName" = true;
  "javascript.inlayHints.propertyDeclarationTypes.enabled" = true;
  "javascript.inlayHints.parameterNames.suppressWhenArgumentMatchesName" = true;
  "javascript.inlayHints.parameterTypes.enabled" = true;

  # Typescript
  "typescript.inlayHints.enumMemberValues.enabled" = true;
  "typescript.inlayHints.functionLikeReturnTypes.enabled" = true;
  "typescript.inlayHints.parameterNames.enabled" = "all";
  "typescript.inlayHints.variableTypes.enabled" = true;
  "typescript.inlayHints.variableTypes.suppressWhenTypeMatchesName" = true;
  "typescript.inlayHints.propertyDeclarationTypes.enabled" = true;
  "typescript.inlayHints.parameterNames.suppressWhenArgumentMatchesName" = true;
  "typescript.inlayHints.parameterTypes.enabled" = true;

  # vscodevim.vim
  "vim.useCtrlKeys" = false;
  "vim.smartRelativeLine" = true;

  # Copilot
  "github.copilot.editor.enableAutoCompletions" = false;
  "chat.commandCenter.enabled" = false;
  "inlineChat.lineNaturalLanguageHint" = false;
  "github.copilot.enable" = {
    "*" = false;
  };

  # --------------------------------------------------
  # Language specific
  # --------------------------------------------------

  "[markdown]" = {
    "editor.defaultFormatter" = "DavidAnson.vscode-markdownlint";
  };

  "[latex][tex][bibtex]" = {
    "editor.defaultFormatter" = "James-Yu.latex-workshop";
  };

  "[c][cpp]" = {
    "editor.defaultFormatter" = "ms-vscode.cpptools";
  };

  "[nix]" = {
    "editor.defaultFormatter" = "kamadorueda.alejandra";
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

  "[typescript][typescriptreact]" = {
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
  };

  "[javascript][javascriptreact]" = {
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
  };

  "[python]" = {
    "editor.defaultFormatter" = "ms-python.autopep8";
    "editor.insertSpaces" = true;
    "editor.tabSize" = 2;
  };

  "[qml]" = {
    "editor.defaultFormatter" = "AndreOneti.qml-formatter";
  };

  "[toml]" = {
    "editor.defaultFormatter" = "tamasfe.even-better-toml";
  };
}
