{
  kernelSrc,
  patchDir,
  runCommand,
  stdenvNoCC,
}:
# This patches the kernel source tree and copies some files
# according to https://github.com/armbian/build/blob/main/patch/kernel/archive/rockchip-rk3588-6.10/0000.patching_config.yaml
# 
# There are probably better ways to do this, but i haven't figured out
# how to do them in pure eval mode.
let
  patchesFile = runCommand "patches" { } ''
    ls -1 ${patchDir}/*.patch > "$out"
  '';
in

stdenvNoCC.mkDerivation {
  name = "patched-kernel-src";
  src = kernelSrc;

  patches = builtins.split "\n" (builtins.readFile patchesFile);

  buildPhase = "true";
  fixupPhase = "true";

  installPhase = ''
    mkdir "$out"
    cp --no-preserve ownership -r $src/* $out

    chmod -R +w "$out"
    cp ${patchDir}/dt/rk3588-nanopc-cm3588-nas.dts "$out/arch/arm64/boot/dts/rockchip/"
    cp -r ${patchDir}/overlay "$out/arch/arm64/boot/dts/rockchip/"
  '';
}
