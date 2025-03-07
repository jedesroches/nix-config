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
      nix-darwin,
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }:
    {
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
          specialArgs = {
            unstablePkgs = nixpkgs-unstable.legacyPackages."${system}";
          };
          modules = [
            home-manager.darwinModules.home-manager
            ./excalibur-configuration.nix
            ./excalibur-home-manager.nix
          ];
        };
      devShell.x86_64-darwin =
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
