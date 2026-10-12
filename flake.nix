{
  description = "Hero's nixos setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake 
    { inherit inputs; } 
    { 
      systems = [ "x86_64-linux" ]; 
      imports = [ (inputs.import-tree ./modules) ]; 
    };
}
