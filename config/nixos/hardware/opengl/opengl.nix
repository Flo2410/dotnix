{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  # ---------------------------------------------------------------------
  # Direct Rendering Infrastructure (DRI) support, both for 32-bit and 64-bit, and
  # Make sure opengl is enabled
  #---------------------------------------------------------------------
  hardware = {
    graphics = {
      enable = true;

      #---------------------------------------------------------------------
      # Install additional packages that improve graphics performance and compatibility.
      #---------------------------------------------------------------------
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        libvdpau-va-gl
        nvidia-vaapi-driver
        # nvidia-thrust-cuda
        # nvidia-thrust-intel
        cudaPackages.cuda_cccl #nvidia-thrust
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        vulkan-validation-layers
      ];
    };
  };
}
