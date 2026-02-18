{ pkgs, config, ... }:

{
  home-manager.users.${config.me.username} = {
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
          C-k = "kill_to_line_end";
        };
        keys.select = {
          G = "extend_to_file_end";
          X = "extend_to_line_end";
        };
        keys.normal = {
          G = "goto_file_end";
          space.w = ":w";
          space.q = ":q";
          "\\" = {
            f = ":reflow";
            F = ":format";
            space = ":toggle whitespace.render all none";
          };
        };
      };
      languages = {
        language-server = {
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
          tofuls = {
            command = "tofu-ls";
            args = [ "serve" ];
          };
        };
        language = [
          {
            name = "nix";
            auto-format = true;
          }

          {
            name = "dhall";
            auto-format = true;
          }

          {
            name = "toml";
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
            name = "haskell";
            auto-format = true;
          }

          {
            name = "racket";
            auto-format = true;
            auto-pairs = {
              "(" = ")";
              "[" = "]";
              "{" = "}";
              "\"" = "\"";
            };
          }

          {
            name = "hcl";
            auto-format = true;
            language-servers = [
              "tofuls"
            ];
          }

          {
            name = "hy";
            grammar = "hy";
            auto-format = true;
            scope = "source.hy";
            file-types = [ "hy" ];
            comment-tokens = [ ";" ];
            indent = {
              tab-width = 2;
              unit = "  ";
            };
          }

          {
            name = "tfvars";
            auto-format = true;
            language-servers = [
              "tofuls"
            ];
          }

          {
            name = "typst";
            auto-format = true;
          }
        ];
        grammar = [
          {
            name = "hy";
            source = {
              git = "https://github.com/kwshi/tree-sitter-hy";
              rev = "main";
            };
          }
        ];
      };
    };
  };
}
