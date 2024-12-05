{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.system.config.plymouth;
in {
  options.system.config.plymouth = {
    enable = mkEnableOption "Enable plymouth";
  };

  config = mkIf cfg.enable {
    boot = {
      plymouth.enable = true;
    };
  };
}
