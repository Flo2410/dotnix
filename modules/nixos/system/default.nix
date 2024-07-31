{
  imports = [
    ./wm/plasma.nix

    ./config

    ./security/firewall.nix

    ./app/logiops/logiops.nix
    ./app/docker.nix
    ./app/flatpak.nix
    ./app/steam.nix
    ./app/virtualization.nix

    ./hardware
  ];
}
