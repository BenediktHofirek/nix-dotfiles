{ inputs, pkgs, ... }: 

{
 programs.plover = {
    enable = true;
    package = inputs.plover-flake.packages.${pkgs.stdenv.hostPlatform.system}.plover.withPlugins (
      ps: with ps; [
        plover-lapwing-aio
      ]
    );

    # Or, use `plover-full` if you want Plover with all the plugins installed:
    # package = inputs.plover-flake.packages.${pkgs.stdenv.hostPlatform.system}.plover-full;

    # (optional) Generate `plover.cfg`:
    settings = {
      "Machine Configuration" = {
        machine_type = "Gemini PR";
        auto_start = true;
      };
      "Output Configuration".undo_levels = 100;
    };
  };
}
