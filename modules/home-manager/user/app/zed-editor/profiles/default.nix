{pkgs}: {
  # AI features
  disable_ai = true;

  theme = {
    light = pkgs.lib.mkForce "Catppuccin Macchiato (sapphire)";
    mode = "system";
  };
}
