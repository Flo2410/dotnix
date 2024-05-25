{ config, lib, inputs, ... }:

with lib;
{
  lib.meta = {
    mkMutableSymlink = path: config.lib.file.mkOutOfStoreSymlink
      (config.user.home-manager.dotfilesDirectory + removePrefix (toString inputs.self) (toString path));
  };
}
