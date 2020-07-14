with import <nixpkgs> {};

let
  env = bundlerEnv {
    name = "sample_app";
    gemdir = ./.;
  };
in
  stdenv.mkDerivation {
    name = "sample_app";
    buildInputs = [ bundix env ruby yarn ];
  }
