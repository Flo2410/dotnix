{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.hardware.opengl;
in {
  options.system.hardware.opengl = {
    enable = mkEnableOption "Enable OpenGL";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mesa-demos
      clinfo
      amdgpu_top
    ];

    hardware.graphics = {
      enable = mkForce true;
      enable32Bit = mkDefault true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
    };

    hardware.amdgpu.initrd.enable = true;
    hardware.enableRedistributableFirmware = true;

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "radeonsi";
    };
  };
}
