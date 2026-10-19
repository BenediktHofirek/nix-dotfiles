{ ... }@inputs:
let 
  constants = import ./_constants.nix;
  functions = import ./_functions.nix inputs;
in
{} // constants // functions
