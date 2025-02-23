{
  pkgs,
  stdenvNoCC,
  ...
}:
stdenvNoCC.mkDerivation rec {
  name = "Xilinx UDEV rules for Digilent USB Devices";
  version = "1.0";
  file_name = "52-xilinx-digilent-usb.rules";

  src = pkgs.writeTextFile {
    name = file_name;
    text = ''
      ###########################################################################
      #                                                                         #
      #  52-digilent-usb.rules -- UDEV rules for Digilent USB Devices           #
      #                                                                         #
      ###########################################################################
      #  Author: MTA                                                            #
      #  Copyright 2010 Digilent Inc.                                           #
      ###########################################################################
      #  File Description:                                                      #
      #                                                                         #
      #  This file contains the rules used by UDEV when creating entries for    #
      #  Digilent USB devices. In order for Digilent's shared libraries and     #
      #  applications to access these devices without root privalages it is     #
      #  necessary for UDEV to create entries for which all users have read     #
      #  and write permission.                                                  #
      #                                                                         #
      #  Usage:                                                                 #
      #                                                                         #
      #  Copy this file to "/etc/udev/rules.d/" and execute                     #
      #  "/sbin/udevcontrol reload_rules" as root. This only needs to be done   #
      #  immediately after installation. Each time you reboot your system the   #
      #  rules are automatically loaded by UDEV.                                #
      #                                                                         #
      ###########################################################################
      #  Revision History:                                                      #
      #                                                                         #
      #  04/15/2010(MTA): created                                               #
      #  02/28/2011(MTA): modified to support FTDI based devices                #
      #  07/10/2012(MTA): modified to work with UDEV versions 098 or newer      #
      #  04/19/2013(MTA): modified mode assignment to use ":=" insetead of "="  #
      #       so that our permission settings can't be overwritten by other     #
      #       rules files                                                       #
      #                                                                         #
      ###########################################################################

      # Create "/dev" entries for Digilent device's with read and write
      # permission granted to all users.
      ATTR{idVendor}=="1443", MODE:="666"
      ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Digilent", MODE:="666"

      # The following rules (if present) cause UDEV to ignore all UEVENTS for
      # which the subsystem is "usb_endpoint" and the action is "add" or
      # "remove". These rules are necessary to work around what appears to be a
      # bug in the Kernel used by Red Hat Enterprise Linux 5/CentOS 5. The Kernel
      # sends UEVENTS to remove and then add entries for the endpoints of a USB
      # device in "/dev" each time a process releases an interface. This occurs
      # each time a data transaction occurs. When an FPGA is configured or flash
      # device is written a large number of transactions take place. If the
      # following lines are commented out then UDEV will be overloaded for a long
      # period of time while it tries to process the massive number of UEVENTS it
      # receives from the kernel. Please note that this work around only applies
      # to systems running RHEL5 or CentOS 5 and as a result the rules will only
      # be present on those systems.
    '';
  };

  # do not unpack the source
  dontUnpack = true;

  installPhase = ''
    install -D $src $out/lib/udev/rules.d/${file_name}
  '';
}
