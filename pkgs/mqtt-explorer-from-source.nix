{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  makeDesktopItem,
  copyDesktopItems,
  desktopToDarwinBundle,
  fixup_yarn_lock,
  makeWrapper,
  nodejs,
  yarn,
  electron,
  python3,
  nodePackages,
  typescript,
}:
stdenv.mkDerivation rec {
  pname = "MQTT-Explorer";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "thomasnordquist";
    repo = "MQTT-Explorer";
    rev = "v${version}";
    hash = "sha256-lXHPKOZh5gbG+kpH9wLBcHztS7fBj9D57ySKd1xkhxc=";
  };

  offlineCacheRoot = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    # hash = "sha256-uvxmIoEUZEKxnyCTwZCy659yFUt3xrQe4xCqacYpelE=";
    hash = "sha256-y/tQY048MyOILaEvI878MupWtDjMLMfVHZGzJ17KWB4=";
  };

  offlineCacheApp = fetchYarnDeps {
    yarnLock = src + "/app/yarn.lock";
    hash = "sha256-uvxmIoEUZEKxnyCTwZCy659yFUt3xrQe4xCqacYpelE=";
  };

  offlineCacheBackend = fetchYarnDeps {
    yarnLock = src + "/backend/yarn.lock";
    hash = "sha256-HZcF0r5Ga5zYXN2Z/+NfvbPNUl2fVkIzcVDfdZAH4NI=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    fixup_yarn_lock
    makeWrapper
    nodejs
    yarn
  ];

  buildInputs = [
    python3
    nodePackages.webpack
    nodePackages.webpack-cli
    typescript
  ];

  ELECTRON_SKIP_BINARY_DOWNLOAD = true;

  configurePhase = ''
    runHook preConfigure

    export HOME="$TMPDIR"

    yarn config --offline set yarn-offline-mirror "$offlineCacheRoot"
    fixup_yarn_lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive

    cd app
    yarn config --offline set yarn-offline-mirror "$offlineCacheApp"
    fixup_yarn_lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive --modules-folder ../node_modules

    cd ../backend
    yarn config --offline set yarn-offline-mirror "$offlineCacheBackend"
    fixup_yarn_lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive --modules-folder ../node_modules

    cd ..
    patchShebangs node_modules/

    runHook postConfigure
  '';

  # NOTE: The build command ``yarn --offline run build`` doesn not work with v0.3.5 as it runs ``yarn rebuild`` without --offline.
  #       This is chages in later version. Therefor this can be replaced on the next update!
  buildPhase = ''
    runHook preBuild

    export NODE_OPTIONS=--openssl-legacy-provider # workaround! See: https://github.com/webpack/webpack/issues/14532

    tsc
    cd app
    webpack --mode production
    cd ..

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r . $out/

    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/dist/src/electron.js

    runHook postInstall
  '';

  # desktopItems = [
  #   (makeDesktopItem {
  #     name = "drawio";
  #     exec = "drawio %U";
  #     icon = "drawio";
  #     desktopName = "drawio";
  #     comment = "draw.io desktop";
  #     mimeTypes = [ "application/vnd.jgraph.mxfile" "application/vnd.visio" ];
  #     categories = [ "Graphics" ];
  #     startupWMClass = "drawio";
  #   })
  # ];

  meta = with lib; {
    description = "An all-round MQTT client that provides a structured topic overview";
    homepage = "https://mqtt-explorer.com/";
    # license = licenses.cc-by-nd-40;
    changelog = "https://github.com/thomasnordquist/MQTT-Explorer/releases/tag/v${version}";
    maintainers = with maintainers; [flo2410];
    platforms = platforms.linux;
  };
}
