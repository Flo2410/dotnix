{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.home;
in {
  options.user.home = {
    enable = mkEnableOption "Enable Home";
    username = mkOption {
      type = types.str;
      default = "florian";
    };
    homeDirectory = mkOption {
      type = types.str;
      default = "/home/florian";
    };
    dotfilesDirectory = mkOption {
      type = types.str;
      default = "/home/florian/dotnix";
    };
  };

  config = mkIf cfg.enable {
    # Home Manager needs a bit of information about you and the paths it should  manage.
    home = {
      username = cfg.username;
      homeDirectory = cfg.homeDirectory;
    };
  };
}
