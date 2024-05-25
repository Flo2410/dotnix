{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.user.app.latte;
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
      ".config/lattedockrc".source = mkOutOfStoreSymlink ./lattedockrc;
      ".config/latte/Default.layout.latte".source = mkOutOfStoreSymlink ./My-Layout.layout.latte;
    };
  };
}
