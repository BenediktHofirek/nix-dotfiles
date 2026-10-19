{
  inputs,
  pkgs,
  username,
  hostname,
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

  services.playerctld.enable = true;

  home.packages = with pkgs; [
    # Nix packages
    comma
    nix-output-monitor
    nix-tree
    nix-diff
    nixfmt
    nixd

    # Hyprland + utils
    wl-clipboard
    waybar
    hyprpicker
    hyprlauncher
    libnotify
    ddcutil
    pavucontrol
    hyprshot
    hyprpaper

    # General system packages
    git
    vim
    nano
    wget
    curl

    # Terminal db client
    rainfrog
    harlequin
    dblab

    # Shell enhancement
    bat
    fd
    ripgrep
    jq
    yq-go
    bottom
    watchexec
    hyperfine
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
    lua
    gcc
    nodejs
    python3
    uv

    # Apps
    google-chrome
    firefox
    slack
    podman-desktop
    vscode

    podman
    plover
    brightnessctl
    pamixer
    grim
    slurp
    wl-gammarelay-rs

  ];

  home.sessionVariables = {
    HYPRSHOT_DIR = "~/shots";
    HOSTNAME = hostname;
    # Combine Nix profile (icons), system/user Flatpak paths (fuzzel)
    XDG_DATA_DIRS = ''
      $HOME/.nix-profile/share:\
      $XDG_DATA_DIRS:\
      /var/lib/flatpak/exports/share:\
      $HOME/.local/share/flatpak/exports/share:\
    '';
  };
}
