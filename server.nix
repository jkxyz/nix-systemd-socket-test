{ buildNpmPackage }:

buildNpmPackage {
  name = "server";
  src = ./server;
  npmDepsHash = "sha256-Ce295qA8Uq2nJZRpMKTmoK03cUiEV/bssnkff4PvwAM=";
  dontNpmBuild = true;
}
