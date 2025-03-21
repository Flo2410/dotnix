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
      userName = "Flo2410";
      userEmail = "florian@hye.dev";

      extraConfig = {
        init.defaultBranch = "main";

        # Sign all commits using ssh key
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/GitHub.pub";

        credential.helper = "store";
      };
    };
  };
}
