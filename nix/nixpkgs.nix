{ inputs, outputs, ... }:
{

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      inputs.nix-matlab.overlay
      inputs.nix-vscode-extensions.overlays.default
      inputs.rust-overlay.overlays.default
      inputs.catppuccin-vsc.overlays.default
    ];

    config.allowUnfree = true;
  };
}
