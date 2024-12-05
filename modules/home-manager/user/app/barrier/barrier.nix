{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.app.barrier;
in {
  options.user.app.barrier = {
    enable = mkEnableOption "Barrier";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (barrier.overrideAttrs (old: {
        postFixup = ''
          substituteInPlace "$out/share/applications/barrier.desktop" --replace "Exec=barrier" "Exec=$out/bin/barrier --config ${./barrier.conf}"
        '';
      }))
    ];
  };
}
