{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.config.git;
in {
  options.user.config.git = {
    enable = mkEnableOption "Enable git";
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.git];

    programs.git = {
      enable = true;

      settings = {
        user = {
          name = "Flo2410";
          email = "florian@hye.dev";
        };

        init.defaultBranch = "main";

        # Sign all commits using ssh key
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/GitHub.pub";

        credential.helper = "store";

        core.quotepath = false;
        i18n = {
          commitencoding = "utf-8";
          logoutputencoding = "utf-8";
        };
      };
    };
  };
}
