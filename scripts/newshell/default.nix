{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "newshell";
      text = ''
        set -eu

        cat << EOF > shell.nix
        let pkgs = import <nixpkgs> {};
        in pkgs.mkShell { buildInputs = with pkgs; []; }
        EOF'';
    })
  ];
}
