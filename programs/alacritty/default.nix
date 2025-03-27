{ pkgs, ... }:

{
  home.packages = with pkgs; [
    unstable.nerd-fonts.roboto-mono
  ];
  programs.alacritty = {
    enable = true;
    settings = {
      window.decorations = "none";
      font = {
        size = 14;
        normal = {
          family = "RobotoMono Nerd Font";
          style = "Regular";
        };
      };
      colors = {
        primary = {
          foreground = "#f2f2f2";
          background = "#000000";
        };
        normal = {
          black = "#000000";
          red = "#cd0000";
          green = "#006400";
          yellow = "#cc6d00";
          blue = "#005ce6";
          magenta = "#b7416e";
          cyan = "#577377";
          white = "#b3b3b3";
        };
        bright = {
          black = "#777777";
          red = "#ff0000";
          green = "#b1d631";
          yellow = "#ff8700";
          blue = "#386296";
          magenta = "#b7416e";
          cyan = "#577377";
          white = "#ffffff";
        };
      };
      selection.save_to_clipboard = true;
    };
  };
  launchd.agents.alacritty = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.alacritty}/bin/alacritty"
        "--daemon"
      ];
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}
