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

    services.udev = {
      enable = mkDefault true;
      packages = [
        (pkgs.stdenvNoCC.mkDerivation {
          name = "LogiOps BLuetooth udev rules";
          version = "1.0";

          src = pkgs.writeTextFile {
            name = "99-logiops-bluetooth.rules";

            text = ''
              ACTION=="add", SUBSYSTEM=="input", ATTRS{uniq}=="dc:8d:4d:24:a7:49", RUN+="${pkgs.systemd}/bin/systemctl start logiops.service"
              ACTION=="remove", SUBSYSTEM=="input", ATTRS{uniq}=="dc:8d:4d:24:a7:49", RUN+="${pkgs.systemd}/bin/systemctl stop logiops.service"
            '';
          };

          # do not unpack the source
          dontUnpack = true;

          installPhase = ''
            install -D $src $out/lib/udev/rules.d/99-logiops-bluetooth.rules
          '';
        })
      ];
    };

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
