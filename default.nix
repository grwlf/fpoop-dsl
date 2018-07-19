{ nixpkgs ? import <nixpkgs> {}
, compiler ? "ghc822"
}:

let
  inherit (nixpkgs) pkgs;

  haskellPackages = pkgs.haskell.packages.${compiler};

  pkg = haskellPackages.mkDerivation {
    pname = "fpoop-dsl";
    version = "0.0.0";
    src = ./.;
    isLibrary = false;
    isExecutable = true;
    libraryHaskellDepends = with haskellPackages; [
      cabal-install ghc haskdogs hasktags containers
      parsec pretty-show
    ];
    license = pkgs.stdenv.lib.licenses.gpl3;
    shellHook = ''
      cabal() {( `which cabal` --ghc-options=-freverse-errors "$@" ; )}
    '';
  };

in
  if pkgs.lib.inNixShell then pkg.env else pkg
