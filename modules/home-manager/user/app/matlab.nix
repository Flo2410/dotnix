{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.app.matlab;
in {
  options.user.app.matlab = {
    enable = mkEnableOption "matlab";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      matlab # from nix-matlab
    ];

    xdg.configFile."nix.sh" = {
      target = "matlab/nix.sh";
      text = ''INSTALL_DIR=$HOME/.local/app/matlab'';
      executable = true;
    };
  };
}
