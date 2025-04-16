{ config, pkgs, ... }:

{
  imports = [
    ../programs/alacritty
    ../programs/direnv
    ../programs/fish
    ../programs/gh
    ../programs/git
    ../programs/helix
    ../programs/jujutsu
    ../programs/mpv
    ../programs/nix
    ../programs/qrcp
    ../programs/starship
    ../scripts/jj-gh-pr
    ../scripts/newshell
    ../scripts/sbb
  ];
  config = {
    home-manager.users.${config.user} = {
      programs = {
        bat.enable = true;
        home-manager.enable = true;
        nix-index.enable = true;
      };
      home = {
        file.hushlogin = {
          enable = true;
          target = ".hushlogin";
          text = "hush";
        };

        packages = with pkgs; [
          # Non project-specific Programming
          nil # Nix LS
          nixfmt-rfc-style # Nix formatter
          statix # Nix linter
          bash-language-server # Sh LS
          shellcheck # Sh linter
          yaml-language-server # YAML LS

          # CLI utilities
          ack # grep but better
          file # Magic file detector
          jq # JSON
        ];
      };
    };
  };
}
