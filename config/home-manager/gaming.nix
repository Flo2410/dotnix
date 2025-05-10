{
  pkgs,
  lib,
  ...
}:
with lib; {
  services.xembed-sni-proxy.enable = mkDefault true; # puts wine systray icons into systray of ags.

  home.packages = with pkgs; [
    lutris
    protontricks
    protonplus

    mangohud
  ];
}
