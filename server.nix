{ buildNpmPackage, lib }:

buildNpmPackage {
  name = "server";
  src = ./server;
  # npmDepsHash = lib.fakeHash;
}
