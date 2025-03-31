{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    package = pkgs.unstable.helix;
    defaultEditor = true;
    settings = {
      theme = "ayu_evolve";
      editor = {
        bufferline = "multiple";
        color-modes = true;
        mouse = false;
        statusline = {
          left = [
            "mode"
            "spinner"
            "version-control"
            "read-only-indicator"
            "file-modification-indicator"
          ];
          center = [ "file-name" ];
          right = [
            "diagnostics"
            "workspace-diagnostics"
            "file-encoding"
            "position"
            "position-percentage"
            "total-line-numbers"
          ];
        };
        soft-wrap.enable = true;
        true-color = true;
      };
      keys.insert = {
        C-n = "completion";
      };
      keys.normal = {
        G = "goto_file_end";
        space.w = ":w";
        space.q = ":q";
      };
    };
    languages = {
      language-server = {
        # Fix for golangci-lint-langserver/issues/51
        # Remove once #52 is merged.
        golangci-lint-lsp = {
          config = {
            command = [
              "golangci-lint"
              "run"
              "--output.json.path"
              "stdout"
              "--show-stats=false"
              "--issues-exit-code=1"
            ];
          };
        };
        nil = {
          command = "nil";
          config = {
            nil = {
              formatting = {
                command = [ "nixfmt" ];
              };
            };
          };
        };
        tinymist = {
          command = "tinymist";
          config = {
            tinymist = {
              formatterMode = "typstyle";
            };
          };
        };
      };
      language = [
        {
          name = "jjdescription";
          scope = "source.jjdescription";
          file-types = [ "jjdescription" ];
          text-width = 72;
          rulers = [ 72 ];
        }

        {
          name = "nix";
          auto-format = true;
        }

        {
          name = "python";
          auto-format = true;
          language-servers = [
            "basedpyright"
            "ruff"
          ];
        }

        {
          name = "typst";
          auto-format = true;
        }
      ];
      grammar = [
        {
          name = "jjdescription";
          source = {
            git = "https://github.com/kareigu/tree-sitter-jjdescription";
            rev = "dev";
          };
        }
      ];
    };
  };
  xdg.configFile."helix-highlights-jj" = {
    enable = true;
    executable = false;
    source =
      pkgs.fetchFromGitHub {
        owner = "kareigu";
        repo = "tree-sitter-jjdescription";
        rev = "dev";
        hash = "sha256-HPghz3mOukXrY0KQllOR7Kkl2U3+ukPBrXWKnJCwsqI=";
      }
      + "/queries/highlights-hx.scm";
    target = "helix/runtime/queries/jjdescription/highlights.scm";
  };
  xdg.configFile."helix-injections-jj" = {
    enable = true;
    executable = false;
    source =
      pkgs.fetchFromGitHub {
        owner = "kareigu";
        repo = "tree-sitter-jjdescription";
        rev = "dev";
        hash = "sha256-HPghz3mOukXrY0KQllOR7Kkl2U3+ukPBrXWKnJCwsqI=";
      }
      + "/queries/injections.scm";
    target = "helix/runtime/queries/jjdescription/injections.scm";
  };
}
