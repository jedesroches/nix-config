let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    nil
    statix
    nixfmt-rfc-style
  ];
}
