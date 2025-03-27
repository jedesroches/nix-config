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
          # background = "#0A0E14";
          background = "#020202";
          foreground = "#B3B1AD";
        };
        normal = {
          # black = "#01060E";
          black = "#0D0D0D";
          # red = "#EA6C73";
          red = "#DD3E25";
          green = "#91B362";
          yellow = "#F9AF4F";
          blue = "#53BDFA";
          magenta = "#FAE994";
          cyan = "#90E1C6";
          white = "#C7C7C7";
        };
        bright = {
          black = "#686868";
          red = "#F07178";
          green = "#C2D94C";
          # yellow = "#FFB454";
          yellow = "#CFCA0D";
          blue = "#59C2FF";
          magenta = "#FFEE99";
          cyan = "#95E6CB";
          white = "#FFFFFF";
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
