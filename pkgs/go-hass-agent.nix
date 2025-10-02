# Source: https://community.home-assistant.io/t/go-hass-agent-a-native-app-integration-for-desktop-laptop-devices/559250/4
{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  xorg,
  mesa,
  glfw,
}:
buildGoModule (finalAttrs: {
  pname = "go-hass-agent";
  version = "13.3.3";

  src = fetchFromGitHub {
    owner = "joshuar";
    repo = "go-hass-agent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gvb/XuNAnypfgHqMnxFwn+8BXTJm4r1TvC8fwLmO5Bk=";
  };

  vendorHash = "sha256-m+4kPNlfZBSW3TGsoYjburKdEo10ysV5AJCr5oDy9qU=";

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

  postInstall = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons

    cp $src/assets/go-hass-agent.desktop $out/share/applications/go-hass-agent.desktop
    cp $src/internal/ui/assets/go-hass-agent.png $out/share/icons/go-hass-agent.png

    substituteInPlace $out/share/applications/go-hass-agent.desktop \
      --replace-warn "Exec=go-hass-agent" "Exec=$out/bin/go-hass-agent"
  '';

  meta = with lib; {
    description = "Go-based Home Assistant agent";
    homepage = "https://github.com/joshuar/go-hass-agent";
    license = licenses.mit;
  };
})
