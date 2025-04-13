{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.config.docker;
in {
  options.user.config.docker = {
    enable = mkEnableOption "Enable Docker config";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [docker-credential-helpers];

    home.file.".docker/config.json".text = builtins.toJSON {
      credsStore = "secretservice";
      currentContext = "default";
    };
  };
}
