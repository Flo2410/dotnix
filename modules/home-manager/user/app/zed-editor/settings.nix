{
  pkgs,
  config,
}: let
  dotfilesDirectory = config.user.home.dotfilesDirectory;
  username = config.user.home.username;
in {
  minimap = {
    show = "auto";
  };
  git = {
    inline_blame = {
      enabled = true;
      show_commit_summary = false;
    };
  };
  project_panel = {
    auto_fold_dirs = false;
  };
  linked_edits = true;
  show_whitespaces = "all";
  tab_size = 2;
  terminal = {
    blinking = "on";
    cursor_shape = "bar";
    font_family = "Fira Code";
  };
  base_keymap = "VSCode";
  telemetry = {
    metrics = false;
    diagnostics = false;
  };
  vim_mode = true;
  ui_font_size = 16;
  buffer_font_size = 13.0;
  theme = {
    mode = "system";
  };
  relative_line_numbers = true;
  format_on_save = "on";
  collaboration_panel = {
    button = false;
  };
  auto_update = false;
  soft_wrap = "none";
  disable_ai = true;

  vim = {
    use_system_clipboard = "on_yank";
    toggle_relative_line_numbers = true;
  };

  # Extension Settings
  ltex = {
    ltex-ls.path = "${pkgs.ltex-ls-plus}";
    java.path = "${pkgs.temurin-bin-21}";
    # ltex-ls.logLevel" = "finest";
    # trace.server" = "verbose";
    language = "de-AT";
    additionalRules.motherTongue = "de-AT";
    additionalRules.enablePickyRules = true;
    configurationTarget = {
      dictionary = "workspaceFolder";
      disabledRules = "workspaceFolder";
      hiddenFalsePositives = "workspaceFolder";
    };
    completionEnabled = true;
    disabledRules = {
      "de-AT" = ["WHITESPACE_RULE"];
    };
  };

  # Language Settings
  languages = {
    Nix = {
      language_servers = ["nixd" "!nil"];
      formatter = {
        external = {
          command = "alejandra"; # or "nixfmt"
          arguments = ["--quiet" "--"];
        };
      };
    };
  };

  # lsp settings
  lsp = {
    texlab = {
      binary.path = "${pkgs.lib.getExe pkgs.texlab}";
      build = {
        onSave = true;
      };
    };
  };
}
