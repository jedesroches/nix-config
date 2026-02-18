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
    ../programs/zk
    ../scripts/jj-gh-pr
    ../scripts/jjm
    ../scripts/newshell
    ../scripts/sbb
  ];
  config = {
    home-manager.users.${config.me.username} = {
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
          bash-language-server # SH LS
          codebook # Spelling LS
          mergiraf # Conflict resolution
          nil # Nix LS
          nixfmt-rfc-style # Nix formatter
          shellcheck # SH linter
          statix # Nix linter
          taplo # TOML LS
          yaml-language-server # YAML LS

          # CLI utilities
          ack # grep but better
          file # Magic file detector
          htop # system process monitoring
          nethack # boring meetings
          jq # JSON

          # For boring meetings
          nethack
        ];
      };
    };
  };
}
