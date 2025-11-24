{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.user.app.mangohud;
in {
  options.user.app.mangohud = {
    enable = lib.mkEnableOption "mangohud";
  };

  config = lib.mkIf cfg.enable {
    catppuccin.mangohud.enable = lib.mkDefault false;
    stylix.targets.mangohud.enable = lib.mkDefault true;

    programs.mangohud = {
      enable = true;
      settings = lib.mkDefault {
        gpu_stats = true;
        gpu_temp = true;
        gpu_power = true;

        cpu_stats = true;
        cpu_temp = true;
        cpu_power = true;
        cpu_mhz = true;

        vram = true;
        ram = true;

        fps = true;
        frametime = true;
        fps_metrics = ["avg" "0.01"];
        throttling_status = true;
        frame_timing = true;

        text_outline = true;
      };
    };
  };
}
