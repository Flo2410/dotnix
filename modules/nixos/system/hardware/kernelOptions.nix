{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.hardware.kernelOptions;
in {
  options.system.hardware.kernelOptions = {
    enable = mkEnableOption "Enable extra kernel options";
  };

  config = mkIf cfg.enable {
    boot.kernelParams = [
      "quiet"
      "splash"
    ];

    boot.extraModulePackages = with config.boot.kernelPackages; [
      # installing https://github.com/DHowett/framework-laptop-kmod
      # (config.boot.kernelPackages.callPackage "${pkgs-unstable.path}/pkgs/os-specific/linux/framework-laptop-kmod/default.nix" { })
    ];
  };
}
