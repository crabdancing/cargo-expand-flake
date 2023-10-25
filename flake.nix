{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    cargo-expand = {
      url = "github:dtolnay/cargo-expand";
      flake = false;
    };
  };

  outputs = { self, flake-utils, naersk, nixpkgs, cargo-expand }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs) {
          inherit system;
        };

        naersk' = pkgs.callPackage naersk {};
      in {
        # For `nix build` & `nix run`:
        defaultPackage = naersk'.buildPackage {
          pname = "cargo-expand";
          src = cargo-expand;
        };

        # For `nix develop`:
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ rustc cargo ];
        };
      }
    );
}

