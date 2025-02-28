{ pkgs, unstablePkgs, ... }:

{
  home.packages = [
    pkgs.difftastic
    unstablePkgs.jjui
  ];
  programs = {
    jujutsu = {
      enable = true;
      package = unstablePkgs.jujutsu;
      settings = {
        user = {
          name = "Joachim Desroches";
          email = "jodesroches@pictet.ch";
        };
        fix = {
          tools = {
            gofmt = {
              command = [
                "gofmt"
                "-s"
              ];
              patterns = [ "glob:'**/*.go'" ];
            };
            nixfmt = {
              command = [
                "nixfmt"
                "-svf"
                "$path"
              ];
              patterns = [ "glob:'**/*.nix'" ];
            };
            statix = {
              command = [
                "statix"
                "fix"
                "-s"
              ];
              patterns = [ "glob:'**/*.nix'" ];
            };
          };
        };
        git = {
          push-bookmark-prefix = "jde/push-";
        };
        ui = {
          default-command = "status";
          diff = {
            tool = [
              "difft"
              "--color=always"
              "$left"
              "$right"
            ];
          };
          movement = {
            edit = true;
          };
          pager = "less -FRX";
        };
        merge-tools.vimdiff.merge-tool-edits-conflict-markers = true;
        revsets.log = "@ | ancestors(remote_bookmarks().., 2) | trunk()";
        templates = {
          # NOTE: this requires jj > 0.25.0
          draft_commit_description = ''
            concat(
              description,
              surround(
                "\nJJ: This commit contains the following changes:\n", "",
                indent("JJ:     ", diff.summary()),
              ),
              "\nJJ: ignore-rest\n",
              diff.git(),
            )'';
        };
      };
    };
    fish = {
      shellAbbrs = {
        jjb = "jj bookmark";
        jjd = "jj diff";
        jje = "jj edit";
        jjf = "jj git fetch";
        jjla = "jj log -r '@ | ancestors(remote_bookmarks()::, 2) | trunk()::'";
        jjl = "jj log";
        jjp = "jj git push";
        jjr = "jj rebase";
        jjrm = "jj rebase -d main";
        jjw = "jj desc -m ";
      };
    };
  };
}
