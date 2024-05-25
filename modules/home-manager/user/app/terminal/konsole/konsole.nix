{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.user.app.terminal.konsole;
  dotfilesDirectory = config.user.home-manager.dotfilesDirectory;

  mkMutableSymlink = config.lib.meta.mkMutableSymlink;
in
{
  options.user.app.terminal.konsole = {
    enable = mkEnableOption "Enable Konsole";
  };

  config = mkIf cfg.enable {
    home.file = {
      "share" = {
        target = ".local/share/konsole";
        source = mkMutableSymlink ./share;
      };

      ".config/konsolerc".source = mkMutableSymlink ./konsolerc;
      ".config/yakuakerc".source = mkMutableSymlink ./yakuakerc;
    };
  };
}
