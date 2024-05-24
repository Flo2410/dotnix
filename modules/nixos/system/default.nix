{
  imports = [
    ./wm/x11-plasma.nix

    ./config/dbus.nix
    ./config/fonts.nix
    ./config/pipewire.nix
    ./config/plymouth.nix

    ./security/firewall.nix
  ];
}
