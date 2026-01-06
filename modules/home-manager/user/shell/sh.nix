{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.shell;

  # add custom theme to oh-my-zsh package
  omz = pkgs.oh-my-zsh.overrideAttrs (old: {
    postInstall =
      (old.postInstall or "")
      + ''
        install -Dm444 ${./robbyrussell-custom.zsh-theme} $out/share/oh-my-zsh/custom/themes/robbyrussell-custom.zsh-theme
      '';
  });
in {
  options.user.shell = {
    enable = mkEnableOption "Enable the shell";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # NOTE: These are here because they are used in shell aliases.
      wl-clipboard
      tldr
      ripgrep
      bat
      eza
      fd
      bc # required by git-fuzzy
      delta

      # Other tools used by the shells.
      direnv
      nix-direnv

      # Command Line
      git
      rsync
      unzip
      fastfetch
      htop
      dig
      # dnsutils
      minicom
      usbutils
      pciutils
      vulkan-tools
      nmap
      jq
      ncdu
      traceroute
      hexyl
      whois
      duf

      git-fuzzy # (callPackage ../pkgs/git-fuzzy.nix { })
    ];

    home.sessionVariables = {
      _ZO_ECHO = 1;
    };

    catppuccin = {
      yazi.enable = false;
    };
    stylix.targets.yazi.enable = true;

    programs = {
      zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        enableCompletion = true;
        shellAliases = import ./aliases.nix;
        initContent = ''
          [ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh" # alias ssh to when using kitty terminal

          zstyle ':completion:*:*:docker:*' option-stacking yes
          zstyle ':completion:*:*:docker-*:*' option-stacking yes
        '';

        oh-my-zsh = {
          enable = true;
          package = omz;
          theme = "robbyrussell-custom";
          plugins = [
            "git"
            "rsync"
            "docker"
          ];
        };
      };

      bash = {
        enable = true;
        enableCompletion = true;
        shellAliases = import ./aliases.nix;
      };

      nushell = {
        enable = true;
        shellAliases = import ./aliases.nix;
        settings = {
          show_banner = false;
          edit_mode = "vi";
        };
        extraConfig = let
          aliases = "${pkgs.nu_scripts}/share/nu_scripts/aliases";
          completions = "${pkgs.nu_scripts}/share/nu_scripts/custom-completions";
          autogen-completions = "${completions}/auto-generate/completions";
        in ''
          def ll [] { ls -l | select name mode user group size modified}
          def l [] { ls -al | select name mode user group size modified}

          def --env mkcd [folder: path] {
            mkdir $folder
            cd $folder
          }

          # nu_scrips aliases
          use ${aliases}/git/git-aliases.nu *

          # nu_scrips custom-completions
          use ${completions}/git/git-completions.nu *
          use ${completions}/ssh/ssh-completions.nu *
          source ${completions}/bat/bat-completions.nu
          source ${completions}/docker/docker-completions.nu
          source ${completions}/nix/nix-completions.nu
          source ${completions}/cargo/cargo-completions.nu
          source ${completions}/tar/tar-completions.nu
          source ${completions}/pnpm/pnpm-completions.nu

          source ${autogen-completions}/nvim.nu
          source ${autogen-completions}/unzip.nu
          source ${autogen-completions}/zip.nu
          source ${autogen-completions}/xz.nu
          source ${autogen-completions}/wget.nu
          source ${autogen-completions}/dd.nu
          source ${autogen-completions}/rsync.nu
          source ${autogen-completions}/gzip.nu
        '';

        environmentVariables = {
          PROMPT_INDICATOR = "";
          PROMPT_INDICATOR_VI_INSERT = "➜ ";
          PROMPT_INDICATOR_VI_NORMAL = ": ";
          PROMPT_MULTILINE_INDICATOR = "::: ";
        };
      };

      # better "cd"
      zoxide = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
        enableNushellIntegration = true;
        options = [
          "--cmd cd"
        ];
      };

      direnv = {
        enable = true;
        enableZshIntegration = true;
        enableNushellIntegration = true;
        nix-direnv.enable = true;
      };

      fzf = {
        enable = true;
        enableZshIntegration = true;
        historyWidgetOptions = [
          "--bind 'ctrl-y:execute-silent(echo -n {2..} | clip)+abort'"
          "--header 'Press CTRL-Y to copy command into clipboard'"
        ];
      };

      atuin = {
        enable = mkDefault true;
        enableZshIntegration = mkDefault true;
        enableBashIntegration = mkDefault true;
        enableNushellIntegration = mkDefault true;
        daemon.enable = mkDefault true;
        settings = {
          auto_sync = mkDefault true;
          sync_address = mkDefault "https://atuin.hye.sh";
          sync_frequency = mkDefault 0; # If set to 0, Atuin will sync after every command. Some servers may potentially rate limit, which won’t cause any issues.
          update_check = mkDefault false;
          enter_accept = mkDefault true;
          filter_mode = mkDefault "global";
          filter_mode_shell_up_key_binding = mkDefault "host";
          style = mkDefault "auto";
          inline_height = 0;
        };
      };

      carapace = {
        enable = true;
        enableNushellIntegration = true;
      };

      starship = {
        enable = true;
        enableNushellIntegration = true;
        enableZshIntegration = mkForce false;
        enableBashIntegration = mkForce false;
        settings = {
          add_newline = false;
          scan_timeout = 10;

          username = {
            show_always = true;
            style_user = "bold sapphire";
            format = "[$user]($style)[@](overlay1)";
          };

          hostname = {
            ssh_only = false;
            style = "bold lavender";
            format = "[$hostname]($style)[:](overlay1)";
          };

          format = lib.concatStrings [
            "$username"
            "$hostname"
            "$directory"
            "$git_branch"
            "$git_state"
            "$git_status"
            "$cmd_duration"
            "$line_break"
            "$character"
          ];

          directory = {
            style = "blue";
          };

          character = {
            success_symbol = "";
            error_symbol = "[✗](bold red)";
            vimcmd_symbol = "";
          };
        };
      };

      yazi = {
        enable = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
        enableBashIntegration = true;

        settings = {
          mgr = {
            sort_by = "natural";
            sort_dir_first = true;
            show_hidden = true;

            prepend_keymap = [
              {
                on = ["c" "m"];
                run = "plugin chmod";
                desc = "Chmod on selected files";
              }
            ];
          };

          plugin = {
            prepend_fetchers = [
              {
                id = "git";
                name = "*";
                run = "git";
              }
              {
                id = "git";
                name = "*/";
                run = "git";
              }
            ];
          };
        };

        plugins = {
          starship = pkgs.yaziPlugins.starship;
          git = pkgs.yaziPlugins.git;
          chmod = pkgs.yaziPlugins.chmod;
          full-border = pkgs.yaziPlugins.full-border;
        };

        initLua = ''
          require("zoxide"):setup()
          require("git"):setup()
          require("starship"):setup()
          require("full-border"):setup()
        '';
      };
    };
  };
}
