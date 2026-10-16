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
    # Nix utils
    comma
    nix-output-monitor
    nixfmt
    nh

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
    wl-clipboard
    brightnessctl
    pamixer
    grim
    slurp
    slack
    wl-gammarelay-rs
    just
  ];
}
