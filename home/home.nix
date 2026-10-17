{ pkgs, username, ... }: {
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  home.username = username;
  home.homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
  home.stateVersion = "26.05";

  programs.bash = {
    enable = true;
    shellAliases.ll = "ls -l";
  };

  home.packages = with pkgs; [ 
    # Nix packages
    comma
    nix-output-monitor
    nixfmt
    nh

    # Hyprland packages
    wl-clipboard

    # General system packages
    git
    vim
    nano
    wget
    curl
    superfile
    google-chrome
    firefox
    waybar
    mako
    awww
    brightnessctl
    pamixer
    grim
    slurp
    slack
    wl-gammarelay-rs
    just
  ];
}
