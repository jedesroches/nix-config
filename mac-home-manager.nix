{ pkgs, ... }:

{
  imports = [
    ./programs/direnv
    ./programs/helix
    ./programs/jujutsu
    ./programs/fish
    ./programs/git
    ./scripts/jj-gh-pr
    ./scripts/sbb
  ];
  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 30d";
  };
  home = {
    packages = with pkgs; [
      ack
      glow
      gh
      shellcheck
      jq
      nil
      nixfmt-rfc-style
      (writeShellApplication {
        name = "newshell";
        text = ''
          set -eux

          cat << EOF > shell.nix
          let pkgs = import <nixpkgs> {}; 
          in pkgs.mkShell { buildInputs = with pkgs; []; }
          EOF'';
      })
    ];
    stateVersion = "24.11";
  };
  programs = {
    home-manager.enable = true;
  };
}
