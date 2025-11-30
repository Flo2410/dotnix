{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.config.ssh;
  entryBefore = lib.hm.dag.entryBefore;
  entryAfter = lib.hm.dag.entryAfter;
in {
  options.user.config.ssh = {
    enable = mkEnableOption "Enabel SSH Client";
  };

  config = mkIf cfg.enable {
    services.ssh-agent.enable = mkDefault true;

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
          hashKnownHosts = false;
          forwardAgent = false;
          identitiesOnly = true;
          compression = true;
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
          userKnownHostsFile = "~/.ssh/known_hosts";
        };

        "github.com" = {
          identityFile = "~/.ssh/GitHub";
        };

        "gitlab.com" = {
          identityFile = "~/.ssh/GitLab_ed25519";
        };

        "es.technikum-wien.at" = {
          identityFile = "~/.ssh/gitlab_embsys_ed25519";
        };

        "pc-florian.*" = entryBefore ["*.hye.network"] {
          user = "florian";
          identityFile = "~/.ssh/pc-florian_ed25519";
          forwardAgent = true;
        };

        "lro" = entryBefore ["*.hye.network"] {
          host = "lro lro.hye.network";
          hostname = "10.56.20.4";
          user = "florian";
          identityFile = "~/.ssh/lro_ed25519";
          forwardAgent = true;
        };

        "milkyway.hye.network" = entryBefore ["*.hye.network"] {
          user = "root";
          identityFile = "~/.ssh/milkyway_ed25519";
          forwardAgent = true;
        };

        "haos.hye.network" = entryBefore ["*.hye.network"] {
          user = "root";
          port = 22222;
          identityFile = "~/.ssh/haos_22222_ed25519";
          forwardAgent = true;
        };

        "ups-pi.hye.network" = entryBefore ["*.hye.network"] {
          user = "florian";
          identityFile = "~/.ssh/ups-pi_ed25519";
          forwardAgent = true;
        };

        "sagittarius-a.hye.network" = entryBefore ["*.hye.network"] {
          user = "florian";
          identityFile = "~/.ssh/sagittarius-a_ed25519";
          forwardAgent = true;
        };

        "*.hye.network" = {
          user = "florian";
          identityFile = "~/.ssh/milkyway_vms_ed25519";
          forwardX11 = true;
          forwardAgent = true;
        };

        "curiosity" = {
          hostname = "curiosity.dsn.hye.network";
          user = "florian";
          identityFile = "~/.ssh/curiosity_ed25519";
          forwardAgent = true;
        };

        "kfj-router" = {
          hostname = "10.56.167.1";
          user = "KFJ-Admin";
        };

        "helios" = {
          hostname = "helios.bird.hye.network";
          user = "florian";
          identityFile = "~/.ssh/helios_ed25519";
          addressFamily = "inet";
          forwardAgent = true;
        };
      };
    };
  };
}
