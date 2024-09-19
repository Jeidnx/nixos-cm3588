{
  fetchFromGitHub,
  linuxManualConfig,
  ...
}:
(linuxManualConfig rec {
  modDirVersion = "6.1.75";
  version = "${modDirVersion}-armbian_vendor";
  extraMeta.branch = "6.1";

  src = fetchFromGitHub {
    owner = "armbian";
    repo = "linux-rockchip";
    rev = "6da82af09c1fa86ee3769a41ec1ae6c054a1bda3";
    hash = "sha256-0u6f5GdDmhDHqgWwM6KOwkNlDpVPrcga6vEZV0CBot0=";
  };

  configfile = ./armbian_config;

  allowImportFromDerivation = true;
})
