{
  fetchFromGitHub,
  linuxManualConfig,
  ...
}:
(linuxManualConfig rec {
  modDirVersion = "6.1.57";
  version = "${modDirVersion}-friendlyarm";
  extraMeta.branch = "6.1";

  src = fetchFromGitHub {
    owner = "friendlyarm";
    repo = "kernel-rockchip";
    rev = "85d0764ec61ebfab6b0d9f6c65f2290068a46fa1";
    hash = "sha256-oGMx0EYfPQb8XxzObs8CXgXS/Q9pE1O5/fP7/ehRUDA=";
  };

  configfile = ./fa_config;

  allowImportFromDerivation = true;
})
