{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.config.keyboard;
  buildLayout = {
    name,
    description,
    lang,
    symbols,
  }: let
    xkbcomp = lib.getExe pkgs.xorg.xkbcomp;
    compilationOutputFile = pkgs.runCommand "${name}-compiled-keyboard-layout" {} ''
      (${xkbcomp} ${symbols} 2> $out) || true
    '';
    compilationOutput = builtins.readFile compilationOutputFile;
    compilationSuccess = compilationOutput == "";
    errorMessage = "Failure compiling layout [${name}]: ${compilationOutput}";
    ifCompilationSuccess = lib.throwIfNot compilationSuccess errorMessage;
  in {
    ${name} = ifCompilationSuccess {
      description = description;
      languages = [lang];
      symbolsFile = symbols;
    };
  };
in {
  options.system.config.keyboard = {
    enable = mkEnableOption "Enable keyboard options";
  };

  # Some info on custom layouts: https://blog.daniel-beskin.com/2025-10-04-validating-custom-keyboard-layouts-on-nixos
  config = mkIf cfg.enable {
    services.xserver.xkb = {
      layout = lib.mkForce "at-custom";
      # variant = lib.mkDefault "nodeadkeys";
      options = lib.mkDefault "caps:escape";
      extraLayouts = buildLayout {
        name = "at-custom";
        description = "Custom German(Austria)";
        lang = "at";
        symbols = ./symbols/at-custom.xkb;
      };
    };
  };
}
