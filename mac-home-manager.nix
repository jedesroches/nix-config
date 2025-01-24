{ pkgs, ... }:

{
  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 30d";
  };
  home = {
    packages = with pkgs; [
      git
      glow
      shellcheck
      jujutsu
      jq
      nil
      nixfmt-rfc-style
    ];
    stateVersion = "24.11";
  };
  programs = {
    helix = {
      enable = true;
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
    };
  };
}
