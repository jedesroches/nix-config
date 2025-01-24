{
  description = "System configuration for my pro macbook";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nix-darwin, home-manager, ... }:
    {
      darwinConfigurations."excalibur" = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          ./mac-configuration.nix
          home-manager.darwinModules.home-manager
          {
            users.users.jde.home = "/Users/jde";
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.jde = import ./mac-home-manager.nix;
            };
          }
        ];
      };
    };
}
