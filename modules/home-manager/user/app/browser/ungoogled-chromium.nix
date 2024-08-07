{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.user.app.browser.ungoogled-chromium;

  chromiumPkg = pkgs.ungoogled-chromium;
in
{
  options.user.app.browser.ungoogled-chromium = {
    enable = mkEnableOption "Enable Ungoogled Chromium";
    defaultBrowser = mkEnableOption "Is default browser";
  };

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = chromiumPkg;
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

      # Installing extensions in ungoogled chromium https://discourse.nixos.org/t/home-manager-ungoogled-chromium-with-extensions/15214
      extensions =
        let
          createChromiumExtensionFor = browserVersion: { id, sha256, version }:
            {
              inherit id;
              crxPath = builtins.fetchurl {
                url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
                name = "${id}.crx";
                inherit sha256;
              };
              inherit version;
            };
          createChromiumExtension = createChromiumExtensionFor (lib.versions.major chromiumPkg.version);
        in
        [
          # (createChromiumExtension {
          #   # ublock origin
          #   id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
          #   sha256 = "sha256:026l3wq4x7rg9f0dz4xiig25x8b7h0syil1d09hbpfzv0yg5bm4m";
          #   version = "1.37.2";
          # })
          (createChromiumExtension {
            # LanguageTool
            id = "oldceeleldhonbafppcapldpdifcinji";
            sha256 = "sha256:083y5mcsk0kvdz8q7f45xnix61irxlnn35lzn9df3jj2l642x05i";
            version = "8.11.6";
          })
        ];
    };

    xdg.mimeApps.defaultApplications = mkIf cfg.defaultBrowser {
      "text/html" = "chromium.desktop";
      "x-scheme-handler/http" = "chromium.desktop";
      "x-scheme-handler/https" = "chromium.desktop";
      "x-scheme-handler/about" = "chromium.desktop";
      "x-scheme-handler/unknown" = "chromium.desktop";
    };

    home.sessionVariables = mkIf cfg.defaultBrowser {
      DEFAULT_BROWSER = "${chromiumPkg}/bin/chromium";
    };
  };
}

