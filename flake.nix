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

    systems = {
      url = "path:./flake-systems.nix";
      flake = false;
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    starship-jj = {
      url = "git+file:///Users/jde/Documents/starship-jj";
      # inputs.nixpkgs.follows = "nixpkgs"; XXX: we need unstable until buildRustPackage uses
      # a version of cargo-auditable that recognizes 2024 edition.
      inputs.systems.follows = "systems";
    };

    nix-secrets = {
      url = "git+ssh://git@github.com/jedesroches/nix-secrets.git?ref=main";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      flake-utils,
      home-manager,
      nix-darwin,
      nix-secrets,
      starship-jj,
      sops-nix,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }:
    {
      overlays = {
        unstable = final: prev: {
          unstable = import nixpkgs-unstable {
            inherit (final) system;
            config.allowUnfree = true;
          };
        };

        starship-jj = final: prev: {
          starship-jj = starship-jj.packages."${prev.system}".starship-jj.overrideAttrs {
            RUSTFLAGS = "-Ctarget-cpu=native";
          };
        };
      };

      # nixosConfigurations."mourneblade" = nixpkgs.lib.nixosSystem {
      #   system = "x86_64-linux";
      #   modules = [ ];
      # };

      darwinConfigurations."excalibur" =
        let
          system = flake-utils.lib.system.x86_64-darwin;
        in
        nix-darwin.lib.darwinSystem {
          inherit system;

          pkgs = import nixpkgs {
            inherit system;
            overlays = nixpkgs.lib.mapAttrsToList (_: value: value) self.overlays;
          };

          modules = [
            # "imports"
            home-manager.darwinModules.home-manager
            sops-nix.darwinModules.sops
            (import ./cachix.nix)

            # SOPS
            (
              { config, ... }:
              {
                sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
                sops.secrets = {
                  nix_access_token = {
                    owner = config.me.username;
                    sopsFile = "${nix-secrets}/jde.yaml";
                  };
                };
              }
            )

            # Nix registry & NIX_PATH
            (
              { lib, config, ... }:
              {
                nix = {
                  registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
                  nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
                };
              }
            )

            # My modules
            ./options.nix
            ./hosts/excalibur.nix
            ./excalibur-home-manager.nix
          ];
        };
    };
}
