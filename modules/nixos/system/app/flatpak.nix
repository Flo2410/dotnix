{ lib, config, inputs, ... }:

with lib;
let
  cfg = config.system.app.flatpak;
in
{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  options.system.app.flatpak = {
    enable = mkEnableOption "Flatpak";
    packages = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    xdg.portal.enable = true;

    services.flatpak = {
      enable = true;
      packages = cfg.packages;
    };
  };
}
