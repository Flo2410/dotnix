{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.user.config.ssh;
  entryBefore = lib.hm.dag.entryBefore;
  entryAfter = lib.hm.dag.entryAfter;
in
{
  options.user.config.ssh = {
    enable = mkEnableOption "Enabel SSH Client";
  };

  config = mkIf cfg.enable {
    services.ssh-agent.enable = mkDefault true;

    programs.ssh = {
      enable = true;
      hashKnownHosts = false;
      forwardAgent = true;
      addKeysToAgent = "yes";
      extraConfig = ''
        IdentitiesOnly yes
      '';
      matchBlocks = {
        "github.com" = {
          identityFile = "~/.ssh/GitHub";
        };

        "lro" = entryBefore [ "*.hye.network" ] {
          host = "lro lro.hye.network";
          hostname = "10.56.20.4";
          user = "florian";
          identityFile = "~/.ssh/lro_ed25519";
        };

        "milkyway.hye.network" = entryBefore [ "*.hye.network" ] {
          user = "root";
          identityFile = "~/.ssh/milkyway_ed25519";
        };

        "haos.hye.network" = entryBefore [ "*.hye.network" ] {
          user = "root";
          port = 22222;
          identityFile = "~/.ssh/haos_22222_ed25519";
        };

        "ups-pi.hye.network" = entryBefore [ "*.hye.network" ] {
          user = "florian";
          identityFile = "~/.ssh/ups-pi_ed25519";
        };

        "sagittarius-a.hye.network" = entryBefore [ "*.hye.network" ] {
          user = "florian";
          identityFile = "~/.ssh/sagittarius-a_ed25519";
        };

        "*.hye.network" = {
          user = "florian";
          identityFile = "~/.ssh/milkyway_vms_ed25519";
        };

        "curiosity" = {
          hostname = "curiosity.dsn.hye.network";
          user = "florian";
          identityFile = "~/.ssh/curiosity_ed25519";
        };

        "kfj-router" = {
          hostname = "10.56.167.1";
          user = "KFJ-Admin";
        };

        "helios" = {
          hostname = "helios.hye.dev";
          user = "florian";
          identityFile = "~/.ssh/helios_ed25519";
          addressFamily = "inet";
        };

        "helios_mount" = {
          hostname = "helios.hye.dev";
          user = "florian";
          identityFile = "~/.ssh/helios_ed25519";
          extraOptions = {
            SessionType = "none";
          };
          localForwards = [
            # nginx proxy manager
            {
              bind.port = 8081;
              host.address = "localhost";
              host.port = 81;
            }

            # minio
            {
              bind.port = 9090;
              host.address = "localhost";
              host.port = 9090;
            }

            # mongodb
            {
              bind.port = 27017;
              host.address = "localhost";
              host.port = 27017;
            }

            # dockge
            {
              bind.port = 5001;
              host.address = "localhost";
              host.port = 5001;
            }
          ];
        };

        "mobi-*" = {
          host = "mobi-* 10.94.160.*";
          user = "mobi";
          compression = true;
          forwardX11 = true;
          identityFile = "~/.ssh/mobi_ed25519";
        };

        "mobi-lambda" = entryAfter [ "mobi-*" ] {
          hostname = "10.94.160.55";
        };

        "mobi-delta" = entryAfter [ "mobi-*" ] {
          hostname = "10.94.160.59";
        };

        "logberry2" = {
          hostname = "10.94.24.177";
          user = "pi";
          identityFile = "~/.ssh/logberry_ed25519";
        };
      };
    };
  };
}
