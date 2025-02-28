let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    nil
    statix
    nixfmt-rfc-style
  ];

  shellHook = ''
    ssh-add -D
    ssh-add ~/.ssh/kleis-gh
  '';
}
