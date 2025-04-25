{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.hardware.fingerprint;
in {
  options.system.hardware.fingerprint = {
    enable = mkEnableOption "Fingerprint sensor";
  };

  config = mkIf cfg.enable {
    # https://community.frame.work/t/framework-nixos-linux-users-self-help-firmware-fingerprint-discussion/46565
    services.fprintd = {
      enable = true;
      # tod = {
      #   enable = true;
      #   driver = pkgs.libfprint-2-tod1-goodix;
      # };
    };

    # https://github.com/NixOS/nixpkgs/issues/239770#issuecomment-1868402338
    security.pam.services.login.fprintAuth = false; # This disables the fingerprint login in sddm

    # Disbale fingerprint auth via pam for Hyprlock!
    # This will be done via fprintd through Hyprlock directly.
    security.pam.services.hyprlock.fprintAuth = mkForce false;
  };
}
