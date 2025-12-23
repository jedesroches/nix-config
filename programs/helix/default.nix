{ pkgs, config, ... }:

let
  tomlFmt = pkgs.formats.toml { };
in
{
  home-manager.users.${config.me.username} = {
    xdg.configFile."helix/snippets/python.toml" = {
      source = tomlFmt.generate "python.toml" {
        snippets = [
          {
            prefix = "def";
            scope = [ "python" ]; # XXX is this necessary considering the file name ?
            body = ''
              def ''${1:fname}(''${2:arg}) -> ''${3:NotImplementedType}:
                  ''${4:return NotImplemented}
            '';
          }
        ];
      };
    };
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
          codebook = {
            command = "codebook-lsp";
            args = [ "serve" ];
          };
          scls = {
            command = "simple-completion-language-server";
            config = {
              feature_citations = false;
              feature_paths = false;
              feature_snippets = true;
              feature_unicode_input = false;
              feature_words = false;
              snippets_first = false;
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
            language-servers = [
              "taplo"
              "codebook"
            ];
          }

          {
            name = "python";
            auto-format = true;
            language-servers = [
              "basedpyright"
              "ruff"
              "codebook"
              "scls"
            ];
          }

          {
            name = "haskell";
            auto-format = true;
            language-servers = [
              "haskell-language-server"
              "codebook"
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
            name = "typst";
            auto-format = true;
            language-servers = [
              "codebook"
              "tinymist"
            ];
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
