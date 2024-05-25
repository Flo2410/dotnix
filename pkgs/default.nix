# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: with pkgs; {

  # Udev
  udev-stm32-named-tty = callPackage ./udev/stm32-named-tty.nix { };
  udev-saleae-logic = callPackage ./udev/saleae-logic.nix { };

  git-fuzzy = callPackage ./git-fuzzy.nix { };

  # # Custom Packages
  # (callPackage ../../user/pkgs/home-assistant-desktop.nix { })
  # (callPackage ../../user/pkgs/elamx2.nix { })
  # # (callPackage ../../user/pkgs/mqtt-explorer.nix { })
}
