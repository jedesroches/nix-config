_:

{
  programs.mpv = {
    enable = true;
    config = {
      cache = "yes";
      demuxer-max-bytes = "1024Mib";
      demuxer-readahead-secs = 20;
    };
  };
}
