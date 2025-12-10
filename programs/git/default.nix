{ config, lib, ... }:

{
  home-manager.users.${config.me.username} = {
    programs = {
      git = {
        enable = true;
        ignores = [
          ".direnv/"
          ".envrc"
          ".local/"
        ];
        settings = {
          aliases = {
            unstage = "reset HEAD --";
          };
          commit.verbose = true;
          core = {
            autocrlf = "input";
            quotepath = "off";
          };
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
          pull.ff = "only";
          rebase.autoSquash = true;
          user = {
            name = "Joachim Desroches";
            email = lib.mkDefault "jdesroches@kleis.ch";
          };
        };
      };
      fish = {
        shellAbbrs = {
          ga = "git add";
          gac = "git commit -a";
          gap = "git add -p ";
          gc = "git commit";
          gd = "git diff";
          gf = "git fetch";
          gp = "git pull";
          gpp = "git push";
          gt = "git status";

        };
        functions = {
          gignore.body = ''for ign in $argv; echo "$ign" >> .gitignore; end '';
          ginit.body = ''git init . && git commit --allow-empty -m "Initial commit"'';
        };
      };
    };
  };
}
