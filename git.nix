{ ... }:

{
  programs = {
    git = {
      enable = true;
      aliases = { unstage = "reset HEAD --"; };
      extraConfig = {
        commit.verbose = true;
        core = {
          autocrlf = "input";
          quotepath = "off";
        };
        push.autoSetupRemote = true;
        pull.ff = "only";
        init.defaultBranch = "main";
        rebase.autoSquash = true;
      };
      ignores = [ ".direnv/" ];
      userEmail = "jdesroches@kleis.ch";
      userName = "Joachim Desroches";
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
        ginit.body =
          ''git init . && git commit --allow-empty -m "Initial commit"'';
      };
    };
  };
}
