{
  description = "Ben's nixos setup";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, import-tree, ... }: 
  flake-parts.lib.mkFlake 
  { inherit inputs; } 
  {
    imports = [
      inputs.home-manager.flakeModules.home-manager
    ];

    systems = [
      "x86_64-linux"
      # "aarch64-linux"
      # "x86_64-darwin"
      # "aarch64-darwin"
    ];

    flake = let
      lib = inputs.nixpkgs.lib;

      hostDirs = lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./hosts);
      hostNames = lib.attrNames hostDirs;

      metaFor = hostname:
        let metaPath = ./hosts/${hostname}/meta.nix;
        in if builtins.pathExists metaPath then import metaPath else {};
    in {
      nixosConfigurations = lib.genAttrs hostNames (hostname:
        let
          meta = metaFor hostname;
          system = meta.system or "x86_64-linux";
          username = meta.username or "hero";
        in
        lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs hostname username; };
          modules = [
            (import-tree ./system)
            ./hosts/${hostname}/configuration.nix
          ] ++ lib.optional (builtins.pathExists ./hosts/${hostname}/hardware.nix)
              ./hosts/${hostname}/hardware.nix;
        }
      );

      homeConfigurations = lib.genAttrs hostNames (hostname:
        let
          meta = metaFor hostname;
          system = meta.system or "x86_64-linux";
          username = meta.username or "hero";
        in
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { inherit inputs hostname username; };
          modules = [
            (import-tree ./home)
          ] ++ lib.optional (builtins.pathExists ./hosts/${hostname}/home.nix)
                  ./hosts/${hostname}/home.nix;
        }
      );
    };
  };
}
