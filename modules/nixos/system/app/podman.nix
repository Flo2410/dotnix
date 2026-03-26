{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.system.app.podman;
in {
  options.system.app.podman = {
    enable = lib.mkEnableOption "Podman";
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      containers.enable = lib.mkDefault true;

      podman = {
        enable = lib.mkDefault true;

        # Create a `docker` alias for podman, to use it as a drop-in replacement
        dockerCompat = lib.mkDefault false;
        dockerSocket.enable = lib.mkDefault false;

        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = lib.mkDefault true;
      };
    };

    environment.systemPackages = with pkgs; [
      dive # look into docker image layers
      podman-tui # status of containers in the terminal
      podman-compose # start group of containers for dev
    ];
  };
}
