{ pkgs, ... }:

{
  home.packages = with pkgs; [ difftastic ];
  programs = {
    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Joachim Desroches";
          email = "jdesroches@kleis.ch";
        };
        fix = {
          tools = {
            # TODO: checkout treefmt
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
          pager = "less -FRX";
        };
        revsets = {
          log = "@ | ancestors(remote_bookmarks().., 2) | trunk()";
        };
        merge-tools.vimdiff.merge-tool-edits-conflict-markers = true;
      };
    };
    fish = {
      shellAbbrs = {
        jjb = "jj bookmark";
        jjd = "jj diff";
        jje = "jj edit";
        jjf = "jj file";
        jjl = "jj log";
        jjla = "jj log -r '@ | ancestors(remote_bookmarks()::, 2) | trunk()::'";
        jjw = "jj desc -m ";
      };
    };
  };
}
