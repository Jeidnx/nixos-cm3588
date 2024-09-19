{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ./rk3588-base.nix ];
  options.hardware.cm3588.kernel = lib.mkOption {
    type = lib.types.strMatching "(armbian-vendor|armbian-current|friendlyarm)";
    default = "armbian-current";
  };

  config =
    let
      isArmbian = lib.strings.hasPrefix "armbian" config.hardware.cm3588.kernel;
    in
    {
      boot = {
        kernelPackages = pkgs.linuxPackagesFor (
          pkgs.callPackage (../pkgs/kernels + "/${config.hardware.cm3588.kernel}") { }
        );

        kernelParams = [
          "consoleblank=0"
          "console=tty1" # HDMI

          # Not sure which one of these is the "correct" uart.
          # Both seem to work.
          # "console=ttyFIQ0,1500000"
          "console=ttyS2,1500000"

          # Additional params in the OEM image
          # "androidboot.mode=normal"
          # "androidboot.dtbo_idx=1"
          # "androidboot.verifiedboottate=orange"
          # "coherent_pool=1m"
          # "irqchip.gicv3_pseudo_nmi=0"

          # optimizations
          "cgroup_enable=cpuset"
          "cgroup_memory=1"
          "cgroup_enable=memory"
          "swapaccount=1" # This option is deprecated
        ];
      };

      enableRedistributableFirmware = lib.mkDefault true;

      hardware = {
        deviceTree = {
          enable = true;
          name =
            if isArmbian then "rockchip/rk3588-nanopc-cm3588-nas.dtb" else "rockchip/rk3588-nanopi6-rev09.dtb";
        };
      };

      # From https://github.com/armbian/build/blob/main/config/boards/nanopc-cm3588-nas.csc
      services.udev.extraRules = lib.optional isArmbian ''
        SUBSYSTEM=="net", ACTION=="add", KERNELS=="0004:41:00.0", NAME:="eth0"

        SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-hdmi0-sound", ENV{SOUND_DESCRIPTION}="HDMI-0 Audio Out"
        SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-hdmi1-sound", ENV{SOUND_DESCRIPTION}="HDMI-1 Audio Out"
        SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-dp0-sound", ENV{SOUND_DESCRIPTION}="DisplayPort-Over-USB Audio Out"
        SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-rt5616-sound", ENV{SOUND_DESCRIPTION}="Headphone Out/Mic In"
        SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-hdmiin-sound", ENV{SOUND_DESCRIPTION}="HDMI-IN Audio In"
      '';
    };
}
