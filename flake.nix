{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    devenv.url = "github:cachix/devenv";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    disko,
    devenv,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    overlays = [];

    pkgs = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };

    lib = import ./lib.nix {
      inherit (nixpkgs) lib;
      inherit pkgs;
      inherit (inputs) home-manager;
    };
  in {
    inherit self lib;

    packages.${system}.devenv-up = self.devShells.${system}.default.config.procfileScript;

    devShells.${system}.default = devenv.lib.mkShell {
      inherit inputs pkgs;
      modules = [
        ./devenv.nix
      ];
    };

    nixosConfigurations.ursa_major = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = let
        username = "kinzoku";
        hostname = "URSA-MAJOR";
      in {
        inherit inputs username hostname;
      };
      modules = [
        disko.nixosModules.disko
        ./hosts/URSA-MAJOR
        ./modules
        (import ./disk-config.nix {
          inherit lib;
          device = "/dev/nvme0n1";
        })
      ];
    };
  };
}
