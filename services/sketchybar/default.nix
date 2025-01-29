{ pkgs, ... }:

{
  services.sketchybar = {
    enable = true;
    extraPackages = with pkgs; [
      jq
      (writeShellApplication {
        name = "setBarDate";
        runtimeInputs = [ sketchybar ];
        text = ''
        sketchybar --set clock label="$(date "+%F %a %H:%M")"
        '';
      })
      (writeShellApplication {
        name = "setBarBattery";
        runtimeInputs = [ sketchybar ];
        text = ''
        sketchybar --set battery \
          label="$(pmset -g batt | grep -Eo "[0-9]+%" | cut -d% -f1)"
        '';
      })
      (writeShellApplication {
        name = "setBarWifi";
        runtimeInputs = [ sketchybar ];
        text = ''
        sketchybar --set wifi \
          label="$(ipconfig getsummary en0 | awk '/ SSID/{ print $3 }')"
        '';
      })
    ];
    config = ''
    sketchybar                         \
      --bar                            \
        color=0xff000000               \
        height=20                      \
        position=top                   \
        padding_left=10                \
        padding_right=10               \
      --default label.color=0xffcc6d00 \
      --default icon.color=0xffcc6d00  \
      --add item clock right           \
      --set clock                      \
        update_freq=10                 \
        script=setBarDate              \
        icon='|'                       \
        label.padding_left=5           \
        background.padding_left=5      \
      --add item battery right         \
      --set battery                    \
        update_freq=30                 \
        script=setBarBattery           \
        icon='|'                       \
        label.padding_left=5           \
        background.padding_left=5      \
      --add item wifi right            \
      --set wifi                       \
        update_freq=30                 \
        script=setBarWifi               
    '';
  };
}
