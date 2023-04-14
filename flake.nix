{
  inputs = {
    rust-overlay.url = "github:oxalica/rust-overlay";
    juuso.url = "github:jhvst/nix-config";
  };
  outputs =
    { self
    , nixpkgs
    , flake-utils
    , rust-overlay
    , juuso
    , ...
    }:
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
          pkgs.libffi
        ];
        packages = with pkgs; [ rustc cargo idris juuso.packages.${system}.savilerow ];
      };
      defaultPackage = pkgs.rustPlatform.buildRustPackage
        {
          pname = "rivi-bqn";
          version = "0.1.0";
          src = ./.;

          cargoLock = {
            lockFile = ./Cargo.lock;
            outputHashes = {
              "rivi-loader-0.2.0" = "5Xr+itpPZ4ZF3GPNlz8NGdiNFyu3JZSdvZQi5jSEZog=";
            };
          };
        };
    });
}
