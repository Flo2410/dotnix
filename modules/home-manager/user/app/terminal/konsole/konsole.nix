{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.user.app.terminal.konsole;
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  options.user.app.terminal.konsole = {
    enable = mkEnableOption "Enable Konsole";
  };

  config = mkIf cfg.enable {
    home.file = {
      "share" = {
        target = ".local/share/konsole";
        source = mkOutOfStoreSymlink ./share;
      };

      ".config/konsolerc".source = mkOutOfStoreSymlink ./konsolerc;
      ".config/yakuakerc".source = mkOutOfStoreSymlink ./yakuakerc;
    };
  };
}
