{
  inputs,
  pkgs,
  username,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  home.username = username;
  home.homeDirectory =
    if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
  home.stateVersion = "26.05";

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  home.packages = with pkgs; [
    # Nix packages
    comma
    nix-output-monitor
    nix-tree
    nix-diff
    nixfmt
    nixd
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

    # Shell enhancement
    bat
    fd
    ripgrep
    jq
    yq-go
    bottom
    watchexec
    hyperfine
    atuin
    tokei
    tealdeer
    dust
    procs
    httpie
    just
    openssl
    lsof
    gnumake
    man-pages
    tree

    # Programming languages and toolchains
    rustc
    cargo
    perl
    php
    go
    python3
    lua
    gcc
    nodejs

    # Apps
    google-chrome
    firefox
    slack

    brightnessctl
    pamixer
    grim
    slurp
    wl-gammarelay-rs
  ];
}
