{ pkgs, config, ... }:

{
  home-manager.users.${config.me.username} = {
    home.packages = with pkgs; [
      (writeShellApplication {
        name = "newshell";
        text = ''
          set -eu

          cat << EOF > shell.nix
          let pkgs = import <nixpkgs> {};
          in pkgs.mkShell { buildInputs = with pkgs; [
            $(for pkg in "$@"; do echo "$pkg"; done)
          ]; }
          EOF'';
      })
    ];
  };
}
