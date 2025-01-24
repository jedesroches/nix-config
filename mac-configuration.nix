{ pkgs, ... }:

{
  system.stateVersion = 5; # See changelog before changing.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nix = {
    optimise.automatic = true;
    settings.experimental-features = "nix-command flakes";
    gc = {
      automatic = true;
      randomizedDelaySec = "5min";
      options = "--delete-older-then 30d";
      dates = "weekly";
    };
  };

  environment.systemPackages = [ pkgs.vim pkgs.git ];
}
