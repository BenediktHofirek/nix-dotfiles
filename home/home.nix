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
    waybar
    mako

    # General system packages
    git
    vim
    neovim
    nano
    wget
    curl

    superfile

    # Apps
    google-chrome
    firefox
    slack

    awww
    brightnessctl
    pamixer
    grim
    slurp
    wl-gammarelay-rs
    just
  ];
}
