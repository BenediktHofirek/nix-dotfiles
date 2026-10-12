{
  description = "Hero's nixos setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake 
    { inherit inputs; } 
    { 
      systems = [ "x86_64-linux" ]; 
      imports = [ 
        inputs.home-manager.flakeModules.home-manager
        (inputs.import-tree ./modules) 
      ]; 
    };
}
