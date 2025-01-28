{ pkgs, ... }:

{
  imports = [
    ./direnv.nix
    ./git.nix
    ./helix.nix
    ./jj.nix
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
    programs = {
      gh.enable = true;
      home-manager.enable = true;
    };
    stateVersion = "24.11";
  };
}
