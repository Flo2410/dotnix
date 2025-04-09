{
  pkgs,
  stdenv,
  ...
}:
stdenv.mkDerivation rec {
  name = "ChipWhisperer udev rules";
  version = "1.0";

  src = pkgs.writeTextFile {
    name = "50-newae.rules";

    text = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2b3e", ATTRS{idProduct}=="*", MODE="0664", GROUP="plugdev"
      SUBSYSTEM=="tty", ATTRS{idVendor}=="2b3e", ATTRS{idProduct}=="*", MODE="0664", GROUP="plugdev", SYMLINK+="cw_serial%n"
      SUBSYSTEM=="tty", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="6124", MODE="0664", GROUP="plugdev", SYMLINK+="cw_bootloader%n"
    '';
  };

  # do not unpack the source
  dontUnpack = true;

  installPhase = ''
    install -D $src $out/lib/udev/rules.d/50-newae.rules
  '';
}
