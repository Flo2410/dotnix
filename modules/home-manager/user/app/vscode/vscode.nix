{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.app.vscode;
in {
  options.user.app.vscode = {
    enable = mkEnableOption "Enable VS Code";
  };

  config = mkIf cfg.enable {
    catppuccin = {
      enable = mkDefault true;
      # optionally configure the extension settings, defaults are shown below:
      vscode = {
        accent = "sapphire";
        settings = {
          boldKeywords = true;
          italicComments = true;
          italicKeywords = true;
          colorOverrides = {};
          customUIColors = {};
          workbenchMode = "default";
          bracketMode = "rainbow";
          extraBordersEnabled = false;
        };
      };
    };

    programs.vscode = {
      enable = true;
      package = pkgs.unstable.vscode.override {
        commandLineArgs = "--password-store=\"gnome-libsecret\"";
      };
      globalSnippets = importJSON ./vs-snippets.code-snippets;
      extensions = import ./extensions.nix {inherit pkgs;};
      userSettings = import ./settings.nix {inherit pkgs config;};
      keybindings = import ./keybindings.nix {};
    };
  };
}
