{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.user.app.browser.vivaldi;
in
{
  options.user.app.browser.vivaldi = {
    enable = mkEnableOption "Enable vivaldi";
    defaultBrowser = mkEnableOption "Is default browser";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (mkIf config.user.wm.plasma.enable kdePackages.plasma-browser-integration)
    ];

    home.file.".config/vivaldi/NativeMessagingHosts/org.kde.plasma.browser_integration.json" = mkIf config.user.wm.plasma.enable {
      text = ''
        {
          "name": "org.kde.plasma.browser_integration",
          "description": "Native connector for KDE Plasma",
          "path": "${pkgs.kdePackages.plasma-browser-integration}/bin/plasma-browser-integration-host",
          "type": "stdio",
          "allowed_origins": [
            "chrome-extension://cimiefiiaegbelhefglklhhakcgmhkai/",
            "chrome-extension://dnnckbejblnejeabhcmhklcaljjpdjeh/"
          ]
        }
      '';
    };

    programs.chromium = {
      enable = true;
      package = pkgs.vivaldi_qt6;
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

    xdg.mimeApps.defaultApplications = mkIf cfg.defaultBrowser {
      "text/html" = "vivaldi-stable.desktop";
      "x-scheme-handler/http" = "vivaldi-stable.desktop";
      "x-scheme-handler/https" = "vivaldi-stable.desktop";
      "x-scheme-handler/about" = "vivaldi-stable.desktop";
      "x-scheme-handler/unknown" = "vivaldi-stable.desktop";
    };

    home.sessionVariables = mkIf cfg.defaultBrowser {
      DEFAULT_BROWSER = "${pkgs.vivaldi_qt6}/bin/vivaldi";
    };
  };
}

