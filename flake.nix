{
  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; };

  outputs = { nixpkgs, self }:
    let pkgs = import nixpkgs { system = "x86_64-linux"; };
    in {
      nixosConfigurations.test = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ ... }: {
            virtualisation.forwardPorts = [{
              from = "host";
              host.port = 3000;
              guest.port = 80;
            }];
          })
        ];
      };

      packages.x86_64-linux.server = pkgs.callPackage (import ./server.nix) {};
    };
}
