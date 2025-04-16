{ pkgs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.jde = {
      imports = [
        ../common/home.nix
      ];

      programs.git.userEmail = "jodesroches@pictet.com";

      home = {
        stateVersion = "24.11"; # XXX DNE - RTFM.

        packages = with pkgs; [
          terraform-ls
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
