# Source: https://community.home-assistant.io/t/go-hass-agent-a-native-app-integration-for-desktop-laptop-devices/559250/4
{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
}:
buildGoModule (finalAttrs: rec {
  pname = "paperless-cli";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ccremer";
    repo = "paperless-cli";
    tag = "v${version}";
    hash = "sha256-JZ7AtG39r1h9btTEwwLxTFOMJoLLomYDxc7A7ZyHzG0=";
  };

  vendorHash = "sha256-oXYVPerpsbpPcnLSL7LB534vAIcLDt6EMqUZbgBlmo4=";

  nativeBuildInputs = [
    pkg-config
  ];

  subPackages = ["."];

  buildInputs = [
  ];

  meta = with lib; {
    description = "CLI tool to interact with paperless-ngx remote API";
    homepage = "https://github.com/ccremer/paperless-cli";
    license = licenses.gpl3;
  };
})
