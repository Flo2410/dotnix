{
  pkgs,
  stdenvNoCC,
  ...
}:
stdenvNoCC.mkDerivation {
  name = "IQUNIX Magi75 udev rules";
  version = "1.0";

  src = pkgs.writeTextFile {
    name = "99-iqunix-magi75.rules";

    text = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="320f", ATTR{idProduct}=="5055", TAG+="uaccess"
      KERNEL=="hidraw*", MODE="0660", GROUP="plugdev", TAG+="uaccess"
    '';
  };

  # do not unpack the source
  dontUnpack = true;

  installPhase = ''
    install -D $src $out/lib/udev/rules.d/99-iqunix-magi75.rules
  '';
}
