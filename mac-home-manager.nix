{ pkgs, ... }:

{
  imports = [ ./direnv.nix ./git.nix ./helix.nix ./jj.nix ];
  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 30d";
  };
  home = {
    packages = with pkgs; [ glow shellcheck jq nil nixfmt-rfc-style ];
    stateVersion = "24.11";
  };
}
