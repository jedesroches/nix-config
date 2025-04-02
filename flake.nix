# NOTE
# Still learning about how all of this composes nicely. Things to keep in mind:
# - https://zimbatm.com/notes/1000-instances-of-nixpkgs
# - https://zimbatm.com/notes/nixpkgs-unfree
# - We think we want everything to be the same across machines, but different
#   architectures make that hard: we need a separate instance of nixpkgs for
#   darwin than for the rest (binary builds are different) and that in turn
#   means two copies of home-manager depending on the arch. Thankfully,
#   inputs are evaluated lazily.

# TODO
# - Is ROCm support useful for my x13 ?

{
  description = "System configuration for my pro macbook";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/master";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-secrets = {
      url = "git+ssh://git@github.com/jedesroches/nix-secrets.git?ref=main";
      flake = false;
    };

    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      home-manager,
      nix-darwin,
      nix-secrets,
      sops-nix,
      stylix,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }:
    let
      darwin = "x86_64-darwin";
      architectures = [
        darwin
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs architectures;
    in
    {
      overlays.unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          system = final.system;
          config.allowUnfree = true;
        };
      };

      # nixosConfigurations."mourneblade" = nixpkgs.lib.nixosSystem {
      #   system = "x86_64-linux";
      #   modules = [ ];
      # };

      darwinConfigurations."excalibur" = nix-darwin.lib.darwinSystem {
        system = darwin;

        pkgs = import nixpkgs {
          system = darwin;
          overlays = [ self.overlays.unstable ];
        };

        modules = [
          home-manager.darwinModules.home-manager
          sops-nix.darwinModules.sops
          stylix.darwinModules.stylix

          (
            { config, ... }:
            {
              sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
              sops.secrets = {
                gh_token = {
                  sopsFile = "${nix-secrets}/jde.yaml";
                };
              };

              home-manager.users.jde.home.file."test" = {
                enable = true;
                text = config.sops.secrets.gh_token.path;
              };
            }
          )

          (
            { lib, config, ... }:
            {
              nix = {
                registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
                nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
              };
            }
          )

          ./options.nix
          ./hosts/excalibur.nix
          ./excalibur-home-manager.nix
        ];
      };

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages."${system}";
        in
        {
          default = pkgs.mkShell {
            name = "nix-config";
            packages = with pkgs; [
              nil
              statix
              nixfmt-rfc-style
            ];
          };
        }
      );
    };
}
