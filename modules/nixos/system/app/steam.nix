{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.app.steam;
in {
  options.system.app.steam = {
    enable = mkEnableOption "Steam";
  };

  config = mkIf cfg.enable {
    hardware.graphics.enable32Bit = mkDefault true;
    programs.steam.enable = true;
  };
}
