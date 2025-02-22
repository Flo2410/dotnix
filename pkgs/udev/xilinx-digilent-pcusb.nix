{
  pkgs,
  stdenvNoCC,
  ...
}:
stdenvNoCC.mkDerivation rec {
  name = "Xilinx pcusb UDEV rules";
  version = "2";
  file_name = "52-xilinx-pcusb.rules";

  src = pkgs.writeTextFile {
    name = file_name;
    text = ''
      # version 0002
      ATTR{idVendor}=="03fd", ATTR{idProduct}=="0008", MODE="666"
      ATTR{idVendor}=="03fd", ATTR{idProduct}=="0007", MODE="666"
      ATTR{idVendor}=="03fd", ATTR{idProduct}=="0009", MODE="666"
      ATTR{idVendor}=="03fd", ATTR{idProduct}=="000d", MODE="666"
      ATTR{idVendor}=="03fd", ATTR{idProduct}=="000f", MODE="666"
      ATTR{idVendor}=="03fd", ATTR{idProduct}=="0013", MODE="666"
      ATTR{idVendor}=="03fd", ATTR{idProduct}=="0015", MODE="666"
    '';
  };

  # do not unpack the source
  dontUnpack = true;

  installPhase = ''
    install -D $src $out/lib/udev/rules.d/${file_name}
  '';
}
