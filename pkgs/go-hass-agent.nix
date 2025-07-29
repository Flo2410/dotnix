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
  version = "13.3.1";

  src = fetchFromGitHub {
    owner = "joshuar";
    repo = "go-hass-agent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K/3z2lxALy1PZM56QT8CZZPdHfRNfgSpyG5vIdKmO+w=";
  };

  vendorHash = "sha256-xgOv+7Z9vYFF7YQn1upbE9n99HyJZHeXQcmgKOUyeAc=";

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

  meta = with lib; {
    description = "Go-based Home Assistant agent";
    homepage = "https://github.com/joshuar/go-hass-agent";
    license = licenses.mit;
  };
})
