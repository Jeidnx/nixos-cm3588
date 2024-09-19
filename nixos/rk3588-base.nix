/*
  MIT License

  Copyright (c) 2023 Ryan Yin

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
*/

# Based on https://github.com/ryan4yin/nixos-rk3588/blob/c4fef04d8c124146e6e99138283e0c57b2ad8e29/modules/boards/base.nix

{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.hardware.cm3588.mali = {
    enableFirmware = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable GPU firmware";
      default = true;
    };
    firmwarePackage = lib.mkOption {
      type = lib.types.package;
      description = "Firmware package for Mali-G610 GPU";
      default = (pkgs.callPackage ../pkgs/mali-firmware { });
    };
  };

  config = {

    boot = {
      supportedFilesystems = [
        "vfat"
        "fat32"
        "exfat"
        "ext4"
        "btrfs"
      ];

      initrd.includeDefaultModules = lib.mkForce false;
      initrd.availableKernelModules = lib.mkForce [
        "nvme"
        "mmc_block"
        "hid"

        "dm_mod" # for LVM & LUKS
        "dm_crypt" # for LUKS
        "input_leds"
      ];
    };

    hardware = {
      opengl.package =
        (
          (pkgs.mesa.override {
            galliumDrivers = [
              "panfrost"
              "swrast"
            ];
            vulkanDrivers = [ "swrast" ];
          }).overrideAttrs
          (_: {
            pname = "mesa-panfork";
            version = "23.0.0-panfork";
            src = pkgs.fetchFromGitLab {
              owner = "panfork";
              repo = "mesa";
              rev = "120202c675749c5ef81ae4c8cdc30019b4de08f4"; # branch: csf
              hash = "sha256-4eZHMiYS+sRDHNBtLZTA8ELZnLns7yT3USU5YQswxQ0=";
            };
          })
        ).drivers;

      firmware =
        [ pkgs.armbian-firmware ]
        ++ (lib.optionals config.hardware.cm3588.mali.enableFirmware [
          config.hardware.cm3588.mali.firmwarePackage
        ]);
    };
  };
}
