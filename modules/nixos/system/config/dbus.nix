{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.system.config.dbus;
in
{
  options.system.config.dbus = {
    enable = mkEnableOption "dbus";
  };

  config = mkIf cfg.enable {
    services.dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    programs.dconf = {
      enable = true;
    };
  };
}
