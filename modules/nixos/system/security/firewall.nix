{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.security.firewall;
in {
  options.system.security.firewall = {
    enable = mkEnableOption "Enable firewall";
  };

  config = mkIf cfg.enable {
    # Firewall
    networking.firewall = let
      ip46tables = "${pkgs.reaction}/bin/ip46tables";
    in {
      enable = cfg.enable;

      # Open ports in the firewall.
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];

      allowedTCPPorts = [
        24800 # barrier
      ];

      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];

      allowedUDPPorts = [
        24800 # barrier
      ];

      # wireguard trips rpfilter up
      # source: https://wiki.nixos.org/wiki/WireGuard#Setting_up_WireGuard_with_NetworkManager
      extraCommands = ''
        ${ip46tables} -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
        ${ip46tables} -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
      '';
      extraStopCommands = ''
        ${ip46tables} -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
        ${ip46tables} -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
      '';
    };
  };
}
