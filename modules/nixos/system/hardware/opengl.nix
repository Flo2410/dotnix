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
      intel-gpu-tools
    ];

    # OpenGL
    nixpkgs.config.packageOverrides = pkgs: {
      intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
    };

    hardware.graphics = {
      enable = mkForce true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        # intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD"; # Force intel-media-driver
    };
  };
}
