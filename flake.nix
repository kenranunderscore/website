{
  description = "Website/blog playground";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let ghcVersion = "94";
    in inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };
      in {
        devShells.default = pkgs.haskellPackages.shellFor {
          packages = p: [ p.website ];
          nativeBuildInputs = [
            pkgs.cabal-install
            pkgs.haskellPackages.cabal-fmt
            pkgs.haskellPackages.fourmolu
            pkgs.haskellPackages.haskell-language-server
          ];
        };
      }) // {
        overlays.default = final: prev: {
          haskellPackages = prev.haskell.packages."ghc${ghcVersion}".override
            (old: {
              overrides =
                final.lib.composeExtensions (old.overrides or (_: _: { }))
                (hfinal: hprev: {
                  website =
                    hfinal.callCabal2nix "website" (final.lib.cleanSource ./.)
                    { };
                });
            });
        };
      };
}
