{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    opam-nix.url = "github:tweag/opam-nix";
    opam-repository = {
      url = "github:ocaml/opam-repository";
      flake = false;
    };
    opam-nix.inputs.opam-repository.follows = "opam-repository";
    opam-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, opam-nix, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (opam-nix.lib.${system}) buildDuneProject;
        package = "newscaml";
        pkgs = nixpkgs.legacyPackages.${system};
        devPackagesQuery = {
          utop = "2.14.0";
          ocaml-lsp-server = "1.19.0";
          ocamlformat = "0.26.2";
        };
        query = devPackagesQuery // {
          ocaml-base-compiler = "5.2.0";
          dream = "1.0.0~alpha7";
          dream-html = "3.6.2";
        };
        scope = buildDuneProject { } package ./. query;
        overlay = final: prev: {
          ${package} = prev.${package}.overrideAttrs (_: {
            # Prevent the ocaml dependencies from leaking into dependent environments
            doNixSupport = false;
          });
        };
        scope' = scope.overrideScope' overlay;
        main = scope'.${package};
        devOpamPackages = builtins.attrValues
          (pkgs.lib.getAttrs (builtins.attrNames devPackagesQuery) scope');
      in
      rec {
        legacyPackages = scope';
        packages.${system}.default = main;
        defaultPackage = main;
        devShell = pkgs.mkShell {
          inputsFrom = [ main ];
          buildInputs = devOpamPackages;
          nativeBuildInputs = with pkgs; [
            gmp
            libev
            pkg-config
          ];
        };
      }
    );
}
