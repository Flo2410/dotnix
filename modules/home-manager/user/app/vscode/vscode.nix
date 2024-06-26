{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.user.app.vscode;
in
{
  options.user.app.vscode = {
    enable = mkEnableOption "Enable VS Code";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      globalSnippets = builtins.fromJSON (builtins.readFile ./vs-snippets.code-snippets);
      extensions = (import ./extensions.nix { inherit pkgs; });
      userSettings = (import ./settings.nix { inherit pkgs config; });
      keybindings = (import ./keybindings.nix { });
    };
  };
}
