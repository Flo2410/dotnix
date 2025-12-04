{
  pkgs,
  config,
}: let
  dotfilesDirectory = config.user.home.dotfilesDirectory;
  username = config.user.home.username;
in {
  git = {
    inline_blame = {
      enabled = true;
      show_commit_summary = false;
    };
  };
  linked_edits = true;
  tab_size = 2;

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

  gutter = {
    line_numbers = true;
    runnables = true;
    breakpoints = true;
    folds = false;
  };
  relative_line_numbers = "enabled";
  sticky_scroll = {
    enabled = false;
  };
  show_whitespaces = "all";
  soft_wrap = "none";

  format_on_save = "on";
  auto_update = false;

  # disable AI features
  disable_ai = true;
  agent = {
    enabled = false;
    button = false;
  };

  collaboration_panel = {
    button = false;
  };

  project_panel = {
    button = true;
    folder_icons = true;
    file_icons = true;
    git_status = true;
    auto_reveal_entries = true;
    auto_fold_dirs = true;
    sticky_scroll = true;
    drag_and_drop = true;
    hide_root = true;
    hide_hidden = false;
  };

  title_bar = {
    show_branch_icon = true;
    show_branch_name = true;
    show_project_items = true;
    show_onboarding_banner = false;
    show_user_picture = false;
    show_sign_in = false;
    show_menus = false;
  };

  terminal = {
    toolbar = {
      breadcrumbs = false;
    };
    blinking = "on";
    cursor_shape = "bar";
    font_family = "Fira Code";
  };

  minimap = {
    show = "auto";
    thumb = "always";
    thumb_border = "none";
    current_line_highlight = null;
  };

  # Tell Zed to use direnv and direnv can use a flake.nix environment
  load_direnv = "direct";

  inlay_hints = {
    enabled = true;
  };

  vim = {
    use_system_clipboard = "on_yank";
    toggle_relative_line_numbers = true;
  };

  # Extension Settings

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
      binary.path = pkgs.lib.getExe pkgs.texlab;
      build = {
        onSave = true;
      };
    };

    rust-analyzer = {
      binary.path = pkgs.lib.getExe pkgs.unstable.rust-analyzer;
    };

    ltex = {
      binary.path = pkgs.lib.getExe pkgs.ltex-ls-plus;
      settings = {
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
      };
    };

    protobuf-language-server = {
      binary.path = pkgs.lib.getExe pkgs.protols;
    };
  };
}
