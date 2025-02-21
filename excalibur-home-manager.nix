{ pkgs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.jde = {

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
        options = "--delete-older-than 7d";
      };

      programs =
        with builtins;
        let
          programs = [
            "bat"
            "home-manager"
            "mpv"
            "nix-index"
          ];
        in
        listToAttrs (
          map (p: {
            name = p;
            value = {
              enable = true;
            };
          }) programs
        );

      home = {
        stateVersion = "24.11"; # XXX DNE - RTFM.
        file.hushlogin = {
          enable = true;
          target = ".hushlogin";
          text = "";
        };

        packages = with pkgs; [
          ack
          glow
          gh
          jq
          mpv
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

    };
  };
}
