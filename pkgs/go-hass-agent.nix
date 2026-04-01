# Source: https://community.home-assistant.io/t/go-hass-agent-a-native-app-integration-for-desktop-laptop-devices/559250/4
{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  xorg,
  mesa,
  glfw,
}: let
  pname = "go-hass-agent";
  version = "14.10.3";

  src = fetchFromGitHub {
    owner = "joshuar";
    repo = "go-hass-agent";
    tag = "v${version}";
    hash = "sha256-7F4zxxMKNrUiKonfO7dQQuODEnFgaFRM7Rzb7n1Erys=";
  };

  jsDeps = buildNpmPackage {
    inherit src version;
    pname = "${pname}-js-deps";
    npmDepsHash = "sha256-baO2S+NNgNgGjMNPrtmgaiiNTHv3vScOXQIVx1Xaxow=";

    buildPhase = ''
      runHook preBuild
      npm run build:js
      npm run build:css
      runHook postBuild
    '';

    installPhase = ''
      mkdir -p $out/lib/web/
      cp ./web/content/*.{js,css} $out/lib/web
    '';
  };
in
  buildGoModule (finalAttrs: {
    inherit src version pname;

    vendorHash = "sha256-WPglpc8xqCW51LmdhGLAuB4jg96T72eRuaS61zagoNw=";

    nativeBuildInputs = [
      pkg-config
    ];

    subPackages = ["."];

    buildInputs =
      [
        mesa
        glfw
      ]
      ++ (with xorg; [
        libX11
        libXrandr
        libXxf86vm
        libXi
        libXcursor
        libXinerama
        libXext
        libxcb
      ]);

    ldflags = [
      "-w -s -X github.com/joshuar/go-hass-agent/config.AppVersion=${version}"
    ];

    postPatch = ''
      cp ${jsDeps}/lib/web/scripts.js ./web/content/scripts.js
      cp ${jsDeps}/lib/web/styles.css ./web/content/styles.css
    '';

    # postInstall = ''
    #   mkdir -p $out/share/applications
    #   mkdir -p $out/share/icons

    #   cp $src/assets/go-hass-agent.desktop $out/share/applications/go-hass-agent.desktop
    #   cp $src/internal/ui/assets/go-hass-agent.png $out/share/icons/go-hass-agent.png

    #   substituteInPlace $out/share/applications/go-hass-agent.desktop \
    #     --replace-warn "Exec=go-hass-agent" "Exec=$out/bin/go-hass-agent"
    # '';

    meta = with lib; {
      description = "Go-based Home Assistant agent";
      homepage = "https://github.com/joshuar/go-hass-agent";
      license = licenses.mit;
    };
  })
