{ pkgs, ... }:
{
  home.packages = with pkgs; [ gh ];
  programs.gh-dash = {
    enable = true;
    package = pkgs.unstable.gh-dash;
  };
}
