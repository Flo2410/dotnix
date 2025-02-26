{
  imports = [
    ./wm/plasma.nix
    ./wm/hyprland.nix

    ./config

    ./security/firewall.nix

    ./app/logiops/logiops.nix
    ./app/docker.nix
    ./app/flatpak.nix
    ./app/steam.nix
    ./app/virtualization.nix
    ./app/thunar.nix

    ./hardware
  ];
}
