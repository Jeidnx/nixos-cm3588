{
  patch,
  lib,
  runCommand,
  fetchgit,
  fetchFromGitHub,
  linuxManualConfig,
  stdenvNoCC,
  ...
}:
let
  kernelVersion = "6.10.9";
  branch = "6.10";

  armbianSrc = fetchFromGitHub {
    owner = "armbian";
    repo = "build";
    rev = "513671a48f687c39eba0d2ea407d693c86590146";
    hash = "sha256-SxHqg18hnlDpIVfxro/cor+Tr4ZPAi4hqCejVvHsxbI=";
  };
  kernelSrc = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    rev = "v${kernelVersion}";
    # rev = "v${kernelVersion}";
    # hash = "sha256-jOEu/cRpB8sbFomp7fvrEBDJRLa/+QBUaODft53Su5M=";
    hash = "sha256-m4Nx767KGbJF4OGs+QDm5xjuTUh3cPCeJxD/bYpn7U0=";
  };
  patchDir = "${armbianSrc}/patch/kernel/archive/rockchip-rk3588-${branch}";
in
(linuxManualConfig {
  modDirVersion = kernelVersion;
  version = "${kernelVersion}-armbian";
  extraMeta.branch = branch;

  # src = kernelSrc;
  # kernelPatches = (import ./getPatches.nix { inherit lib runCommand patchDir; });
  src = import ./patch-kernel.nix {
    inherit
      runCommand
      stdenvNoCC
      patchDir
      kernelSrc
      ;
  };

  # configfile = ./config.new;
  configfile = runCommand "patched-config" { } ''
    ${patch}/bin/patch -o "$out" ${armbianSrc}/config/kernel/linux-rockchip-rk3588-${branch}.config ${./config.patch}
  '';

  allowImportFromDerivation = true;
})
