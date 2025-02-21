# I don't use vim as a daily driver, but vimdiff is useful for conflicts
_:

{

  programs.vim = {
    enable = true;
    extraConfig = ''
      set nocompatible
      set nobackup
      set number
      set mouse=
      set breakindent
      syntax on
    '';
  };

}
