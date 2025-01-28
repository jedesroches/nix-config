{ ... }:

{
  services.yabai = {
    enable = true;
    config = {
      active_window_opacity = 1.0;
      focus_follows_mouse = "autofocus";
      layout = "bsp";
      normal_window_opacity = 0.9;
      split_ratio = 0.5;

      mouse_modifier = "fn";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      mouse_drop_action = "swap";

      top_padding = 8;
      bottom_padding = 8;
      left_padding = 8;
      right_padding = 8;
      window_gap = 10;

      window_insertion_point = "first";
      window_opacity = "on";
      window_origin_display = "cursor";
      window_placement = "second_child";
      window_shadow = "float";
    };
    extraConfig = ''
      yabai -m rule --add app='^System Settings$' manage=off
      yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off
  '';
  };
}
