{ pkgs, ... }:

{
  programs.rofi = {

    enable = true;

    package = pkgs.rofi;

    theme = "DarkBlue";

  };
}
