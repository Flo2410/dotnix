{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.app.xilinx-vivado;
in {
  options.user.app.xilinx-vivado = {
    enable = mkEnableOption "xilinx-vivado";
  };

  # This uses the nix-xilinx overlay
  # https://github.com/KaminariOS/nix-xilinx

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vivado
    ];

    xdg.configFile."xilinx-nix.sh" = {
      target = "xilinx/nix.sh";
      text = ''
        INSTALL_DIR=$HOME/.local/app/Xilinx
        # The directory in which there's a /bin/ directory for each product, for example:
        # $HOME/downloads/software/xilinx/Vivado/2022.1/bin
        VERSION=2016.1
      '';
      executable = true;
    };
  };
}
