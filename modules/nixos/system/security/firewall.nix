{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.system.security.firewall;
in
{
  options.system.security.firewall = {
    enable = mkEnableOption "Enable firewall";
  };

  config = mkIf cfg.enable {
    # Firewall
    networking.firewall = {
      enable = true;

      # Open ports in the firewall.
      allowedTCPPortRanges = [
        { from = 1714; to = 1764; } # KDE Connect
      ];

      allowedTCPPorts = [
        24800 # barrier
      ];

      allowedUDPPortRanges = [
        { from = 1714; to = 1764; } # KDE Connect
      ];

      allowedUDPPorts = [
        24800 # barrier
      ];
    };
  };
}
