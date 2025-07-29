# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs:
with pkgs; {
  # Udev
  udev-stm32-named-tty = callPackage ./udev/stm32-named-tty.nix {};
  udev-saleae-logic = callPackage ./udev/saleae-logic.nix {};
  udev-ft232h = callPackage ./udev/ft232h.nix {};
  udev-xilinx-digilent-usb = callPackage ./udev/xilinx-digilent-usb.nix {};
  udev-xilinx-digilent-pcusb = callPackage ./udev/xilinx-digilent-pcusb.nix {};
  udev-chipwhisperer = callPackage ./udev/chipwhisperer.nix {};

  git-fuzzy = callPackage ./git-fuzzy.nix {};

  # Custom Packages
  home-assistant-desktop = callPackage ./home-assistant-desktop.nix {};
  elamx2 = callPackage ./elamx2.nix {};
  stm32cubeprog = callPackage ./stm32cubeprog.nix {};
  breezex-cursor = callPackage ./breezex-cursor.nix {};
  bahnschrift-font = callPackage ./bahnschrift-font.nix {};
  go-hass-agent = callPackage ./go-hass-agent.nix {};
  mkshell = callPackage ./mkshell.nix {};

  mfcl3750cdw = callPackage ./brother-mfcl3750cdw.nix {};

  sddm-astronaut = callPackage ./sddm-themes/astronaut.nix {};
}
