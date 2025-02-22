_:

{
  programs.mpv = {
    enable = true;
    config = {
      demuxer-max-bytes = "200000KiB";
    };
  };
}
