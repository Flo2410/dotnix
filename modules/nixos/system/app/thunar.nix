{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
with lib; let
  cfg = config.system.app.thunar;
in {
  options.system.app.thunar = {
    enable = mkEnableOption "Thunar";
  };

  config = mkIf cfg.enable {
    programs.thunar = {
      enable = mkDefault true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };
}
