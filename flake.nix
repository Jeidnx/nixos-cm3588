{
  description = "FriendlyElec CM3588 NixOS support";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs:
    let
      lib = inputs.nixpkgs.lib;
      mkEfiImage =
        pkgOpts: extraCfg:
        (inputs.nixpkgs.lib.nixosSystem {
          pkgs = import inputs.nixpkgs (
            pkgOpts
            // {
              config.allowUnfreePredicate =
                pkg:
                builtins.elem (lib.getName pkg) [
                  "armbian-firmware"
                  "armbian-firmware-unstable"
                ];
            }
          );
          modules = [
            ./nixos/cm3588.nix
            ./nixos/installer.nix
            "${inputs.nixpkgs-unstable}/nixos/modules/image/repart.nix" # Current stable is broken.
            "${inputs.nixpkgs}/nixos/modules/profiles/base.nix"

            extraCfg
          ];
        }).config.system.build.image;

      swapConfig = {
        image.repart.partitions."50-swap".repartConfig = {
          Type = "linux-generic";
          Label = "swap";
          SizeMinBytes = "4G";
          SizeMaxBytes = "10G";
          Weight = "333";
        };
      };

    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      flake.nixosModules = {
        cm3588-hardware = ./nixos/cm3588.nix;
      };

      flake.efi-img = mkEfiImage {
        system = "aarch64-linux";
      } { };

      flake.efi-img-swap = mkEfiImage {
        system = "aarch64-linux";
      } swapConfig;

      perSystem =
        {
          pkgs,
          system,
          ...
        }:
        {
          packages.efi-img-cross = mkEfiImage {
            inherit system;
            crossSystem.config = "aarch64-linux";
          } { };

          packages.efi-img-cross-swap = mkEfiImage {
            inherit system;
            crossSystem.config = "aarch64-linux";
          } swapConfig;

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              minicom
              rkdeveloptool
            ];
          };
        };
    };
}
