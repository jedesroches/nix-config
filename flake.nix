# NOTE
# Still learning about how all of this composes nicely. Things to keep in mind:
# - https://zimbatm.com/notes/1000-instances-of-nixpkgs
# - https://zimbatm.com/notes/nixpkgs-unfree
# - We think we want everything to be the same across machines, but different
#   architectures make that hard: we need a separate instance of nixpkgs for
#   darwin than for the rest (binary builds are different) and that in turn
#   means two copies of home-manager depending on the arch. Thankfully,
#   inputs are evaluated lazily.

{
  description = "System configuration for my pro macbook";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/master";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nix-darwin,
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }:
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
      darwinConfigurations."excalibur" =
        let
          system = "x86_64-darwin";
        in
        nix-darwin.lib.darwinSystem {
          inherit system;
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.unstable ];
          };
          modules = [
            home-manager.darwinModules.home-manager
            ./excalibur-configuration.nix
            ./excalibur-home-manager.nix
          ];
        };
      devShells.x86_64-darwin.default =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-darwin;
        in
        pkgs.mkShell {
          name = "nix-config";
          packages = with pkgs; [
            nil
            statix
            nixfmt-rfc-style
          ];
          shellHook = ''
            ssh-add -D
            ssh-add ~/.ssh/kleis-gh
          '';
        };
    };
}
