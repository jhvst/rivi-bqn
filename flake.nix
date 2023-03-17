{
  inputs = {
    rust-overlay.url = "github:oxalica/rust-overlay";
  };
  outputs = { self, nixpkgs, flake-utils, rust-overlay, ... }:
    let
      system = "x86_64-darwin";
      pkgs = import nixpkgs { inherit system; };
      juuso = builtins.fetchTarball {
        url = "https://github.com/jhvst/nix-config/archive/refs/heads/main.zip";
        sha256 = "117wdhyqw6knlh66ykn8ibiya93hp0r84lird9pihnimxy29lxm0";
      };
      savilerow = pkgs.callPackage (import "${juuso}/pkgs/savilerow/default.nix") { };
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
        rustVersion = pkgs.rust-bin.stable.latest.default;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            (rustVersion.override { extensions = [ "rust-src" ]; })
          ];
          packages = with pkgs; [ libffi rustc cargo idris savilerow ];
        };
        defaultPackage = pkgs.rustPlatform.buildRustPackage
          {
            pname = "rivi-bqn";
            version = "0.1.0";
            src = ./.;

            buildInputs = [ pkgs.libffi ];

            cargoLock = {
              lockFile = ./Cargo.lock;
              outputHashes = {
                "cbqn-0.0.8" = "Qt7WPbVA0KjyYo/2Jl00dTy+0/GgSa9ihjZ+DxIUGgw=";
                "rivi-loader-0.2.0" = "5Xr+itpPZ4ZF3GPNlz8NGdiNFyu3JZSdvZQi5jSEZog=";
              };
            };
          };
      });
}
