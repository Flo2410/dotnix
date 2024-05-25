{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.user.app.browser.vivaldi;
in
{
  options.user.app.browser.vivaldi = {
    enable = mkEnableOption "Enable vivaldi";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      plasma-browser-integration
    ];

    home.file.".config/vivaldi/NativeMessagingHosts/org.kde.plasma.browser_integration.json".text = ''
      {
        "name": "org.kde.plasma.browser_integration",
        "description": "Native connector for KDE Plasma",
        "path": "${pkgs.plasma-browser-integration}/bin/plasma-browser-integration-host",
        "type": "stdio",
        "allowed_origins": [
          "chrome-extension://cimiefiiaegbelhefglklhhakcgmhkai/",
          "chrome-extension://dnnckbejblnejeabhcmhklcaljjpdjeh/"
        ]
      }
    '';

    programs.chromium = {
      enable = true;
      package = pkgs.unstable.vivaldi;
      commandLineArgs = [
        "--enable-gpu-rasterization"
        "--enable-quic"
        "--enable-zero-copy"
        "--force-dark-mode"
        "--ignore-gpu-blocklist"
        "--use-vulkan"
        "--enable-features=ParallelDownloading,UnexpireFlagsM90,VaapiVideoDecoder,Vulkan"
        "--disable-smooth-scrolling"
      ];
    };

    xdg.mimeApps.defaultApplications = {
      "text/html" = "vivaldi-stable.desktop";
      "x-scheme-handler/http" = "vivaldi-stable.desktop";
      "x-scheme-handler/https" = "vivaldi-stable.desktop";
      "x-scheme-handler/about" = "vivaldi-stable.desktop";
      "x-scheme-handler/unknown" = "vivaldi-stable.desktop";
    };

    home.sessionVariables = {
      DEFAULT_BROWSER = "${pkgs.unstable.vivaldi}/bin/vivaldi";
    };
  };
}

