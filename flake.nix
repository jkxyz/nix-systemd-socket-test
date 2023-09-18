{
  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; };

  outputs = { nixpkgs, self }:
    let pkgs = import nixpkgs { system = "x86_64-linux"; };
    in {
      nixosConfigurations.test = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, ... }: {
            imports = [ "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix" ];

            system.stateVersion = "23.05";

            boot.loader.grub.enable = false;

            virtualisation.graphics = false;

            virtualisation.forwardPorts = [{
              from = "host";
              host.port = 3000;
              guest.port = 80;
            }];

            networking.firewall.allowedTCPPorts = [ 80 ];

            users.mutableUsers = false;
            users.users.root.password = "";

            systemd.services.server = {
              after = [ "network.target" ];
              wantedBy = [ "multi-user.target" ];
              serviceConfig = {
                Type = "simple";
                ExecStart =
                  "${pkgs.nodejs}/bin/node ${self.packages.x86_64-linux.server}/lib/node_modules/server/main.js";
                Restart = "on-failure";
              };
            };

            services.nginx = {
              enable = true;

              virtualHosts."localhost" = {
                locations."/" = { proxyPass = "http://localhost:3000/"; };
              };
            };
          })
        ];
      };

      packages.x86_64-linux.server = pkgs.callPackage (import ./server.nix) { };
    };
}
