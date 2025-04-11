{ pkgs, config, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.jde = {
      imports = [
        ./programs/alacritty
        ./programs/direnv
        ./programs/fish
        ./programs/git
        ./programs/gh
        ./programs/helix
        ./programs/jujutsu
        ./programs/mpv
        ./programs/starship
        ./scripts/jj-gh-pr
        ./scripts/sbb
        ./scripts/newshell
      ];

      nix = {
        extraOptions = ''
          keep-derivations = true
          !include ${config.sops.secrets.nix_access_token.path}
        '';
        gc = {
          automatic = true;
          frequency = "weekly";
          options = "--delete-older-than 7d";
        };
      };

      programs = {
        bat.enable = true;
        home-manager.enable = true;
        nix-index.enable = true;
      };

      home = {
        stateVersion = "24.11"; # XXX DNE - RTFM.
        file.hushlogin = {
          enable = true;
          target = ".hushlogin";
          text = "hush";
        };

        packages = with pkgs; [
          ack
          bash-language-server
          jq
          mpv
          nil
          nixfmt-rfc-style
          shellcheck
          statix
          terraform-ls
          yaml-language-server
          (writeShellApplication {
            name = "cycle-ssh";
            text = ''
              if ssh-add -L | grep -q kleis;
              then
                KEY="$HOME/.ssh/id_ed25519"
              else
                KEY="$HOME/.ssh/kleis-gh"
              fi

              ssh-add -D
              ssh-add "$KEY"
            '';
          })
        ];
      };

    };
  };
}
