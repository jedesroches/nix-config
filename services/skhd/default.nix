{ ... }:

{
  services.skhd = {
    enable = true;
    skhdConfig = ''
    cmd - return : yabai -m window --warp first
    cmd + shift - return : alacritty msg new-window
    '';
  };
}
