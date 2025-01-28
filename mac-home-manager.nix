{ pkgs, ... }:

{
  imports = [
    ./programs/alacritty
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
    stateVersion = "24.11"; # XXX DNE - RTFM.
    file.ghosttyConfig = {
      enable = true;
      executable = false;
      target = ".config/ghostty/config";
      text = ''
      window-decoration = false
      window-padding-x = 0
      window-padding-y = 0
      auto-update = download
      '';
    };
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
  };
  programs = {
    home-manager.enable = true;
  };
}
