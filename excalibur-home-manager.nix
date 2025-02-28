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

      programs =
        with builtins;
        let
          programs = [
            "bat"
            "home-manager"
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
        ];
      };

    };
  };
}
