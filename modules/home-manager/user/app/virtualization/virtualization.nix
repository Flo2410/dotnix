{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.app.virtualization;
in {
  options.user.app.virtualization = {
    enable = mkEnableOption "Enable virtualization";
    hasWin11 = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    # Various packages related to virtualization, compatability and sandboxing
    home.packages = with pkgs;
      [
        # Virtual Machines
        libvirt
        qemu
        virt-manager
        virt-viewer
      ]
      ++ (
        if cfg.hasWin11
        then [
          (pkgs.writeShellScriptBin "windows-11" ''
            virt-viewer --connect qemu:///system --domain-name "win11" --attach --wait &
            virsh --connect qemu:///system start "win11"
          '')

          (pkgs.makeDesktopItem {
            name = "windows-11";
            desktopName = "Windows 11";
            exec = "windows-11";
            terminal = false;
            type = "Application";
            icon = ../../../../../assets/icons/win11.png;
          })
        ]
        else []
      );

    home.file.".config/libvirt/qemu.conf".text = ''
      nvram = ["/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd"]
    '';
  };
}
