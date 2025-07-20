{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.hardware.printing;
in {
  options.system.hardware.printing = {
    enable = mkEnableOption "Enable printing";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.cups-filters];

    # Enable printing
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        ptouch-driver
        brlaser
        gutenprint
        mfcl3750cdw.cupswrapper
      ];
      extraFilesConf = ''
        FileDevice Yes
      '';
      logLevel = "debug";
    };

    services.avahi = {
      enable = true;
      #nssmdns4 = true;
      openFirewall = true;
    };
  };
}
