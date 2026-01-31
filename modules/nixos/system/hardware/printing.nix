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

    hardware.printers = {
      ensurePrinters = [
        {
          name = "Brother_Printer";
          description = "Brother Printer";
          deviceUri = "https://brother-printer.dsn.hye.network:631";
          model = "brother_mfcl3740cdw_printer_en.ppd"; #"everywhere";  # use "lpinfo -m" to find model
          ppdOptions = {
            PageSize = "A4";
            Duplex = "DuplexNoTumble";
          };
        }
      ];
      ensureDefaultPrinter = "Brother_Printer";
    };
  };
}
