{
  pkgs,
  stdenv,
  ...
}:
stdenv.mkDerivation rec {
  name = "Saleae Logic Analyzer udev rules";
  version = "1.0";

  src = pkgs.writeTextFile {
    name = "99-SaleaeLogic.rules";

    text = ''
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="0925", ATTR{idProduct}=="3881", MODE="0666"
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1001", MODE="0666"
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1003", MODE="0666"
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1004", MODE="0666"
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1005", MODE="0666"
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1006", MODE="0666"
    '';
  };

  # do not unpack the source
  dontUnpack = true;

  installPhase = ''
    install -D $src $out/lib/udev/rules.d/99-SaleaeLogic.rules
  '';
}
