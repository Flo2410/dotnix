{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.user.shell;

  # add custom theme to oh-my-zsh package
  omz = pkgs.oh-my-zsh.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      install -Dm444 ${./robbyrussell-custom.zsh-theme} $out/share/oh-my-zsh/custom/themes/robbyrussell-custom.zsh-theme
    '';
  });
in
{
  options.user.shell = {
    enable = mkEnableOption "Enable the shell";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # NOTE: These are here because they are used in shell aliases.
      xclip
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
      zsh
      git
      rsync
      unzip
      fastfetch
      btop
      htop
      dig
      dnsutils
      minicom
      usbutils
      nmap
      jq
      ncdu

      git-fuzzy # (callPackage ../pkgs/git-fuzzy.nix { })
    ];

    programs = {
      zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        enableCompletion = true;
        shellAliases = (import ./aliases.nix);

        oh-my-zsh = {
          enable = true;
          package = omz;
          theme = "robbyrussell-custom";
          plugins = [
            "git"
            "rsync"
          ];
        };
      };

      bash = {
        enable = true;
        enableCompletion = true;
        shellAliases = (import ./aliases.nix);
      };

      # better "cd"
      zoxide = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
        options = [
          "--cmd cd"
        ];
      };

      direnv = {
        enable = true;
        enableZshIntegration = true;
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

    };
  };
}
