{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.purescript
    pkgs.spago
    pkgs.nodejs
  ];
}
