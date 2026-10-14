{ self, inputs, ... }: {

  # This is your system configuration entry-point
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.laptopModule
      self.nixosModules.myHomeManager
    ];
  };

}

