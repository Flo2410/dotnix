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

  # MATLAB                                                Version 24.2        (R2024b)
  # Antenna Toolbox                                       Version 24.2        (R2024b)
  # Communications Toolbox                                Version 24.2        (R2024b)
  # Computer Vision Toolbox                               Version 24.2        (R2024b)
  # DSP System Toolbox                                    Version 24.2        (R2024b)
  # Image Processing Toolbox                              Version 24.2        (R2024b)
  # Satellite Communications Toolbox                      Version 24.2        (R2024b)
  # Signal Processing Toolbox                             Version 24.2        (R2024b)
  # Statistics and Machine Learning Toolbox               Version 24.2        (R2024b)
  # Symbolic Math Toolbox                                 Version 24.2        (R2024b)

  # FHTW Moderne Regelungskonzepte
  # Simulink
  # Control System Toolbox
  # Signal Processing Toolbox
  # Simscape
  # Simscape Electrical
  # Simulink Control Design
  # Symbolic Math Toolbox

  # https://gitlab.com/doronbehar/nix-matlab
  # For Installation:
  # nix run gitlab:doronbehar/nix-matlab#matlab-shell
  # To run MATLAB:
  # nix run gitlab:doronbehar/nix-matlab

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
