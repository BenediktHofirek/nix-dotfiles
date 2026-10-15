{ pkgs, username, ... }: {
  nixpkgs.config.allowUnfree = true;

  home.username = username;
  home.homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";
  home.stateVersion = "25.11";

  programs.bash.enable = true;
  programs.bash.shellAliases.ll = "ls -l";

  home.packages = with pkgs; [ 
    git
    vim
    nano
    wget
    curl
    kitty 
    superfile
    google-chrome
    firefox
  ];
}
