{ config, pkgs, ... }:

{
  home-manager = {
    users.${config.me.username} = {
      programs.git.userEmail = "jdesroches@kleis.ch";

      home.packages = (with pkgs; [

        # Network utilities
        dig

        # Desktop tools
        calibre # ebooks
        feh # Image viewer
        i3lock # Screen lock
        imagemagick # magic for images
        libreoffice # office thingy
        poppler_utils # pdf manipulation tools
        scrot # Screenshots
        shotwell # Picture library manager
        qrencode # Share stuff using qrcodes
        qrcp # wifi transfer of files
        xclip # Xorg clipboard manipulation
        jetbrains.idea-ultimate

        # Communication tools
        whatsapp-for-linux

        # Documents
        pandoc
        texliveFull

        # Non project-specific Programming
        nil # Nix LS
        nixfmt-rfc-style # Nix formatter
        nodePackages.bash-language-server
        shellcheck

        # CLI utilities
        ack # grep but better
        linux-wifi-hotspot
        ffmpeg # Video processing
        file # Magic file detector
        jpegoptim # Image optimizer
        jq # JSON
        lsof # List Open Files
        mtr # network info
        tig # Git cli browser
        ytfzf

        # Archivers
        unzip
        zip

        # Home-made packages
        (callPackage "/home/jde/projects/rust/spectrbar/" { })
        (callPackage "/home/jde/projects/nix/rofi-dmenu/" { })

        # Shell scripts
        (writeShellApplication {
          name = "screen-above";
          runtimeInputs = [ gawk xorg.xrandr ];
          text = ''
            xrandr | awk '!/eDP-1/ && / connected/ { print $1; }' |
              while read -r externalscreen;
              do
                xrandr --output eDP-1 --auto;
                xrandr --output "$externalscreen" --auto --above eDP-1;
              done
          '';
        })
        (writeShellApplication {
          name = "screen-small";
          runtimeInputs = [ gawk xorg.xrandr ];
          text = ''
            xrandr | awk '!/eDP-1/ && /connected [0-9]{0,4}x[0-9]{0,4}/ { print $1; }' |
              while read -r externalscreen;
              do
                xrandr --output "$externalscreen" --off;
              done
            xrandr --output eDP-1 --auto;
          '';
        })
        (writeShellApplication {
          name = "screen-large";
          runtimeInputs = [ gawk xorg.xrandr ];
          text = ''
            xrandr | awk '!/eDP-1/ && / connected/ { print $1 }' |
              while read -r externalscreen;
              do
                xrandr --output "$externalscreen" --auto;
              done
            xrandr --output eDP-1 --off
          '';
        })
        (writeShellApplication {
          name = "qb-pipe";
          runtimeInputs = [ qutebrowser ];
          text = ''
            cat "$@" > /tmp/tmpfile.html && qutebrowser /tmp/tmpfile.html
          '';
        })
      ]);
    };
  };
}
