{
  description = "MLIR Tutorial";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    let
      llvmVersion = "21";
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        llvmPkgs = pkgs."llvmPackages_${llvmVersion}";
      in
      {
        devShells.default = pkgs.mkShell.override { stdenv = llvmPkgs.stdenv; } {
          name = "mlir";
          nativeBuildInputs = [
            llvmPkgs.clang-tools
            llvmPkgs.clang
            llvmPkgs.llvm.dev
            llvmPkgs.mlir
          ];
        };
      }
    );
}
