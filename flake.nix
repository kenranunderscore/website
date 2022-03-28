{
  description = "WIP website";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";

  outputs = { self, nixpkgs }:
    let system = "x86_64-linux";
    in {
      packages.${system}.default =
        let pkgs = import nixpkgs { inherit system; };
        in pkgs.stdenv.mkDerivation {
          name = "org-website";
          version = "0.0.1";
          # FIXME(Johannes): refine
          src = pkgs.lib.cleanSource ./.;
          buildInputs = [
            # Add Emacs packages here, so we don't have to make the
            # blog an FOD or run it without sandboxing because of
            # having to download them.
            (pkgs.emacsWithPackages
              (p: with p; [ f htmlize haskell-mode clojure-mode nix-mode ]))
          ];
          buildPhase = ''
            export HOME=$TMP
            emacs --script publish.el
          '';
          installPhase = "mkdir -p $out && cp -r html $out/site";
        };
    };
}
