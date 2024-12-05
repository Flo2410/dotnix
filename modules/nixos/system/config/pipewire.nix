{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.system.config.pipewire;
in {
  options.system.config.pipewire = {
    enable = mkEnableOption "Enable Pipewire audio";
  };

  config = mkIf cfg.enable {
    hardware.pulseaudio.enable = false;

    # Pipewire
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };
}
