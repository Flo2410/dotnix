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
      glxinfo
      clinfo
      amdgpu_top
    ];

    hardware.graphics = {
      enable = mkForce true;
      enable32Bit = mkDefault true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
        amdvlk
      ];
    };

    hardware.amdgpu.initrd.enable = true;
    hardware.enableRedistributableFirmware = true;

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "radeonsi";
    };
  };
}
