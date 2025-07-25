{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f{
      pkgs = import nixpkgs {inherit system;};
    });
  in 
  {
#	  devShells."x86_64-linux".default = 
#		import ./shell.nix {inherit pkgs;};

    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell.override
      {
        # Jos halutaan vaikka käyttää Clang niin 
        # stdenv = pkgs.clangStdenv;
      }
      {
        packages = with pkgs; [ 
          vcpkg
          cmake
          # gcc
		      # clang
        ] ++ (if system == "aarch64-darwin" then [ ] else [gdb]);


	      shellHook = ''
		      echo "welcome to the shell"
	      '';

      };
    });
  };
}
