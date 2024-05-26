{ inputs, outputs, config, lib, pkgs, ... }:

let
  cfg = config.system.config.user;
in
{
  options.system.config.user = {
    user = lib.mkOption {
      default = "florian";
      type = lib.types.str;
    };
    home-manager = {
      enable = lib.mkEnableOption "home-manager";
      home = lib.mkOption {
        default = ../../../home-manager;
        type = lib.types.path;
      };
    };
  };

  config = {
    home-manager = lib.mkIf cfg.home-manager.enable {
      useGlobalPkgs = lib.mkDefault true;
      useUserPackages = lib.mkDefault false;
      extraSpecialArgs = { inherit inputs outputs; };
      # sharedModules = builtins.attrValues outputs.homeManagerModules;
      users."${cfg.user}" = import cfg.home-manager.home;
    };

    users = {
      defaultUserShell = pkgs.zsh;
      users.${cfg.user} = {
        isNormalUser = true;
        uid = 1000;
        extraGroups = [ "networkmanager" "wheel" "input" "dialout" "video" "libvirtd" ];
      };
    };
  };
}
