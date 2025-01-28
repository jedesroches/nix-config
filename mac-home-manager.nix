{ pkgs, ... }:

{
  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 30d";
  };
  home = {
    packages = with pkgs; [
      git
      glow
      shellcheck
      jujutsu
      jq
      nil
      nixfmt-rfc-style
    ];
    stateVersion = "24.11";
  };
  programs = import ./helix.nix;
}
