{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.user.app.latte;
  dotfilesDirectory = config.user.home.dotfilesDirectory;

  mkMutableSymlink = config.lib.meta.mkMutableSymlink;
in
{
  options.user.app.latte = {
    enable = mkEnableOption "Enable latte dock";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      latte-dock
    ];

    home.file = {
      ".config/lattedockrc".source = mkMutableSymlink ./lattedockrc;
      ".config/latte/Default.layout.latte".source = mkMutableSymlink ./My-Layout.layout.latte;
    };
  };
}
