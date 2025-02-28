{ pkgs, unstablePkgs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.jde = {
      imports = [
        { _module.args = { inherit unstablePkgs; }; }
        ./programs/alacritty
        ./programs/direnv
        ./programs/fish
        ./programs/git
        ./programs/helix
        ./programs/jujutsu
        ./programs/mpv
        ./scripts/jj-gh-pr
        ./scripts/sbb
        ./scripts/newshell
      ];

      nix.gc = {
        automatic = true;
        frequency = "weekly";
        options = "--delete-older-than 7d";
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
          glow
          gh
          jq
          mpv
          shellcheck
          bash-language-server
          terraform-ls
          yaml-language-server
        ];
      };

    };
  };
}
