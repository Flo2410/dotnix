{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.system.app.lemonade;
in {
  options.system.app.lemonade = {
    enable = lib.mkEnableOption "Enable Lemonade local AI server";
  };

  config = lib.mkIf cfg.enable {
    systemd.settings.Manager = {
      DefaultIOAccounting = true;
      DefaultIPAccounting = true;
      DefaultLimitMEMLOCK = "infinity";
    };

    hardware = {
      amdnpu.enable = lib.mkDefault true;
      amd-npu = {
        enable = lib.mkDefault true;
        enableFastFlowLM = lib.mkDefault true; # LLM inference on NPU
        enableLemonade = lib.mkDefault true; # OpenAI-compatible API server
        enableROCm = lib.mkDefault true; # Declaratively wires ROCm GPU backends for Lemonade
        enableVulkan = lib.mkDefault true; # Declaratively wires Vulkan GPU backends for Lemonade
        lemonade.user = "florian";
      };
    };
  };
}
