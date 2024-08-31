# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: with pkgs; {

  # Udev
  udev-stm32-named-tty = callPackage ./udev/stm32-named-tty.nix { };
  udev-saleae-logic = callPackage ./udev/saleae-logic.nix { };
  udev-ft232h = callPackage ./udev/ft232h.nix { };

  git-fuzzy = callPackage ./git-fuzzy.nix { };

  # Custom Packages
  home-assistant-desktop = callPackage ./home-assistant-desktop.nix { };
  elamx2 = callPackage ./elamx2.nix { };
  mqtt-explorer = callPackage ./mqtt-explorer.nix { };
  olauncher = callPackage ./olauncher.nix { };
  stm32cubeprog = callPackage ./stm32cubeprog.nix { };
  breezex-cursor = callPackage ./breezex-cursor.nix { };

  sddm-astronaut = callPackage ./sddm-themes/astronaut.nix { };
}
