{ pkgs, ... }:

{
  programs = {
    rofi = {
      enable = true;
      theme = pkgs.rofi + /share/rofi/themes/gruvbox-dark.rasi;
      pass.enable = true;
    };
  };
  xdg.dataFile = {
    "rofi/dmenu-theme.rasi" = { source = ./dmenu-theme.rasi; };
  };
}
