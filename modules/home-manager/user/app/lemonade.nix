{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.user.app.lemonade;
in {
  options.user.app.lemonade = {
    enable = lib.mkEnableOption "Enable lemonade for AMD NPU";
    enableZedIntegration = lib.mkEnableOption "Enable Zed integration for lemonade";
  };

  config = lib.mkIf cfg.enable {
    home.packages = let
      mkChromePWA = config.lib.meta.mkChromePWA;
    in [
      (mkChromePWA {
        domain = "localhost:13305";
        https = false;
        version = "1.0";
        icon = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/lemonade-sdk/lemonade/refs/heads/main/src/app/assets/logo.svg";
          sha256 = "sha256-v6ZLKz8xl3UV8TgChaRh2Cq7VMDsGiUbk1i9EABRS3E=";
        };
        desktopName = "Lemonade";
      })
    ];

    programs.zed-editor.userSettings = lib.mkIf cfg.enableZedIntegration {
      language_models = {
        openai_compatible = {
          "Lemonade" = {
            api_url = "http://localhost:13305/api/v1";
            available_models = [
              {
                name = "qwen3-4b-FLM";
                display_name = "qwen3:4b FLM";
                max_tokens = 32768;
                capabilities = {
                  tools = true;
                  images = false;
                  parallel_tool_calls = false;
                  prompt_cache_key = false;
                  chat_completions = true;
                };
              }
              {
                name = "qwen3-it-4b-FLM";
                display_name = "qwen3-it:4b FLM";
                max_tokens = 32768;
                capabilities = {
                  tools = true;
                  images = false;
                  parallel_tool_calls = false;
                  prompt_cache_key = false;
                  chat_completions = true;
                };
              }
              {
                name = "llama3.2-1b-FLM";
                display_name = "llama3.2:1b FLM";
                max_tokens = 131072;
                capabilities = {
                  tools = false;
                  images = false;
                  parallel_tool_calls = false;
                  prompt_cache_key = false;
                  chat_completions = true;
                };
              }
              {
                name = "llama3.1-8b-FLM";
                display_name = "llama3.1:8b FLM";
                max_tokens = 16384;
                capabilities = {
                  tools = false;
                  images = false;
                  parallel_tool_calls = false;
                  prompt_cache_key = false;
                  chat_completions = true;
                };
              }
              {
                name = "Qwen3-Coder-30B-A3B-Instruct-GGUF";
                display_name = "Qwen3-Coder-30B-A3B-Instruct-GGUF llamacpp";
                max_tokens = 262144;
                capabilities = {
                  tools = false;
                  images = false;
                  parallel_tool_calls = false;
                  prompt_cache_key = false;
                  chat_completions = true;
                };
              }
            ];
          };
        };
      };
    };
  };
}
