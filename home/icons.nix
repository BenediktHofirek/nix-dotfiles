{ pkgs, ... }:

{
  # 1. Install Icon Theme Packages
  home.packages = with pkgs; [
    papirus-icon-theme
    adwaita-icon-theme
    colloid-icon-theme
  ];

  # 2. Set environment variables so launchers and DEs find user icons
  home.sessionVariables = {
    XDG_DATA_DIRS = "$HOME/.nix-profile/share:$XDG_DATA_DIRS";
  };

  # 3. Configure GTK Apps (GTK2, GTK3, GTK4)
  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark"; # Options: "Papirus", "Papirus-Dark", "Papirus-Light", "MoreWaita", "Colloid-dark", etc.
      package = pkgs.papirus-icon-theme;
    };

    # Optional: Match cursor & font for a unified look
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };

  # 4. Configure Qt Apps to mirror the GTK Icon/Style Theme
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-dark";
  };
}
