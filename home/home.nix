{ pkgs, ... }:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./kitty.nix
    ./rofi.nix
  ];

  home.username = "dev";
  home.homeDirectory = "/home/dev";

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    firefox
    google-chrome

    dunst
    hyprpaper

    wl-clipboard

    grim
    slurp

    brightnessctl
    playerctl

    pavucontrol
  ];

  services.dunst.enable = true;
}
