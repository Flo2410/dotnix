{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.app.logiops;
in {
  options.system.app.logiops = {
    enable = mkEnableOption "LogiOps";
  };

  config = mkIf cfg.enable {
    # Install logiops package
    environment.systemPackages = [pkgs.logiops];

    # Create systemd service
    systemd.services.logiops = {
      description = "An unofficial userspace driver for HID++ Logitech devices";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.logiops}/bin/logid";
      };
    };

    # Configuration for logiops
    environment.etc."logid.cfg".source = ./logid.cfg;
  };
}
