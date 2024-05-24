{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.system.app.virtualization;
in
{
  options.system.app.virtualization = {
    enable = mkEnableOption "Virtualization";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      virt-manager
      virtiofsd
    ];

    virtualisation.libvirtd = {
      allowedBridges = [
        "nm-bridge"
        "virbr0"
      ];
      enable = true;
      qemu.runAsRoot = true;
      qemu.ovmf.enable = true;
    };
  };
}
