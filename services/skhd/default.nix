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
    '';
  };
}
