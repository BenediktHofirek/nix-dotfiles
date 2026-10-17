{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    inter
    liberation_ttf
    noto-fonts
    noto-fonts-color-emoji
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "CaskaydiaCove Nerd Font Mono" ];
      sansSerif = [ "Inter" ];
      emoji     = [ "Noto Color Emoji" ];
    };
  };
}
