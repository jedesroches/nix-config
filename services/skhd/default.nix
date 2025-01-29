{ pkgs, ... }:

{
  # FIXME: c.f.  koekeishiya/skhd#342
  system.activationScripts.postActivation.text = ''
    su - "$(logname)" -c '${pkgs.skhd}/bin/skhd -r'
  '';
  services.skhd = {
    enable = true;
    skhdConfig = ''
    cmd - return : yabai -m window --warp first
    cmd + shift - return : alacritty msg create-window

    cmd - h : yabai -m window --focus west
    cmd - j : yabai -m window --focus south
    cmd - k : yabai -m window --focus north
    cmd - l : yabai -m window --focus east

    shift + cmd - h : yabai -m window --warp west
    shift + cmd - j : yabai -m window --warp south
    shift + cmd - k : yabai -m window --warp north
    shift + cmd - l : yabai -m window --warp east
    '';
  };
}
