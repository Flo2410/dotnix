{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./opengl/opengl.nix
  ];

  hardware = {
    enableAllFirmware = true;
    nvidia = {
      modesetting.enable = true;
      nvidiaPersistenced = true;

      # Enable the Nvidia settings menu
      nvidiaSettings = true;

      # Enable power management
      powerManagement.enable = true; # Fix Suspend issue

      # Select the appropriate driver version for your GPU
      # package = config.boot.kernelPackages.nvidiaPackages.production;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      # package = config.boot.kernelPackages.nvidiaPackages.beta;
      # package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;

      open = true;
    };
  };

  boot.extraModprobeConfig =
    "options nvidia "
    + lib.concatStringsSep " " [
      # nvidia assume that by default your CPU does not support PAT,
      # but this is effectively never the case in 2023
      "NVreg_UsePageAttributeTable=1"
      # This may be a noop, but it's somewhat uncertain
      "NVreg_EnablePCIeGen3=1"
      # This is sometimes needed for ddc/ci support, see
      # https://www.ddcutil.com/nvidia/
      #
      # Current monitor does not support it, but this is useful for
      # the future
      "NVreg_RegistryDwords=RMUseSwI2c=0x01;RMI2cSpeed=100"
      # When (if!) I get another nvidia GPU, check for resizeable bar
      # settings
    ];

  # Set environment variables related to NVIDIA graphics
  environment.variables = {
    # Required to run the correct GBM backend for nvidia GPUs on wayland
    GBM_BACKEND = "nvidia-drm";
    # Apparently, without this nouveau may attempt to be used instead
    # (despite it being blacklisted)
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # Hardware cursors are currently broken on nvidia
    LIBVA_DRIVER_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    __GL_THREADED_OPTIMIZATION = "1";
    __GL_SHADER_CACHE = "1";

    NVD_BACKEND = "direct";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };

  # Specify the Nvidia video driver for Xorg
  services.xserver.videoDrivers = ["nvidia"];

  boot.kernelParams = ["module_blacklist=amdgpu"];

  # Packages related to NVIDIA graphics
  environment.systemPackages =
    (with pkgs; [
      clinfo
      gwe
      nvtopPackages.nvidia
      virtualglLib
      vulkan-loader
      vulkan-tools
    ])
    ++ (with pkgs.cudaPackages; [
      cuda_nvcc
      cudatoolkit
    ]);
}
