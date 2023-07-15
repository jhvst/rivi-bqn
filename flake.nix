{
  inputs = {
    naersk.url = "github:nix-community/naersk";
    juuso.url = "github:jhvst/nix-config";
  };
  outputs =
    { self
    , nixpkgs
    , flake-utils
    , naersk
    , juuso
    , ...
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      naersk' = pkgs.callPackage naersk { };
      pkgs = import nixpkgs { inherit system; };
      nativeBuildInputs = with pkgs; [ pkgconfig libffi libiconv cbqn ];
    in
    {
      devShells.default = pkgs.mkShell {
        inherit nativeBuildInputs;
        packages = with pkgs; [
          rustc
          cargo
          idris
          juuso.packages.${system}.savilerow
          nodejs

          (pkgs.darwin.apple_sdk_11_0.callPackage "${toString self.inputs.nixpkgs}/pkgs/os-specific/darwin/moltenvk" {
            inherit (pkgs.darwin.apple_sdk_11_0.frameworks) AppKit Foundation Metal QuartzCore;
            inherit (pkgs.darwin.apple_sdk_11_0) MacOSX-SDK Libsystem;
            inherit (pkgs.darwin) cctools sigtool;
          })
        ];
      };
      defaultPackage = naersk'.buildPackage {
        inherit nativeBuildInputs;

        pname = "rivi-bqn";
        version = "0.1.0";
        src = ./.;

      };
    });
}
