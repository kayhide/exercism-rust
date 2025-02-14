{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    let
      overlay = final: prev:
        {
          app-env = prev.buildEnv {
            name = "app-env";
            paths = with final; [
              rustc
              rust-analyzer
              cargo
              clippy
              evcxr
              rustfmt
            ];
          };
        };

      perSystem = system:
        let
          pkgs = import inputs.nixpkgs { inherit system; overlays = [ overlay ]; };
        in
        {
          devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
              app-env

              entr
              gnumake
            ];
          };
        };
    in
    { inherit overlay; } // inputs.flake-utils.lib.eachDefaultSystem perSystem;
}
