{
  pkgs,
  stdenv,
  ...
}:
stdenv.mkDerivation rec {
  name = "FTDI FT232H udev rules";
  version = "1.0";

  src = pkgs.writeTextFile {
    name = "11-ft232h.rules";

    text = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6001", GROUP="plugdev", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6011", GROUP="plugdev", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6010", GROUP="plugdev", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6014", GROUP="plugdev", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6015", GROUP="plugdev", MODE="0666"
    '';
  };

  # do not unpack the source
  dontUnpack = true;

  installPhase = ''
    install -D $src $out/lib/udev/rules.d/11-ft232h.rules
  '';
}
