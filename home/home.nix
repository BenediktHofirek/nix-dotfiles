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

    # Bluetooth
    blueman
    bluetui

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
    gtop
    nvitop
    htop
    btop
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
    direnv
    nix-direnv
    killall

    # Apps
    google-chrome
    chromium
    firefox
    slack
    podman-desktop
    vscode
    kdePackages.dolphin
    libreoffice

    podman
    podman-compose
    brightnessctl
    pamixer
    grim
    slurp
    wl-gammarelay-rs

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

    # Lua
    lua-language-server
    stylua

    # Go
    gopls
    gotools
    templ

    # Python
    python313Packages.python-lsp-server
    ruff
    mypy

    # Rust
    rust-analyzer

    # Web
    vscode-langservers-extracted
    emmet-language-server
    tailwindcss-language-server
    vtsls
    vue-language-server
    graphql-language-service-cli

    # Docker
    dockerfile-language-server
    docker-compose-language-service

    # Shell / data
    bash-language-server
    yaml-language-server

    # Nix
    nixd
    nixfmt

    # Terraform
    terraform-ls
    tflint

    # PHP
    phpactor

    # SQL
    sqls
  ];

  home.sessionVariables = {
    # Combine Nix profile (icons), system/user Flatpak paths (fuzzel)
    XDG_DATA_DIRS = ''
      $HOME/.nix-profile/share:\
      $XDG_DATA_DIRS:\
      /var/lib/flatpak/exports/share:\
      $HOME/.local/share/flatpak/exports/share:\
    '';
  };
}
