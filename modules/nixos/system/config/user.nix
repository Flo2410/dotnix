{ inputs, outputs, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.system.config.user;
in
{
  options.system.config.user = {
    user = mkOption {
      default = "florian";
      type = types.str;
    };
    authorizedKeys = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
    home-manager = {
      enable = mkEnableOption "home-manager";
      home = mkOption {
        default = ../../../home-manager;
        type = types.path;
      };
    };
  };

  config = {
    home-manager = mkIf cfg.home-manager.enable {
      useGlobalPkgs = mkDefault true;
      useUserPackages = mkDefault false;
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
        openssh.authorizedKeys.keys = cfg.authorizedKeys;
      };
    };
  };
}
