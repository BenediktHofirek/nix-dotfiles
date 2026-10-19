{ username, hostname, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    # vim keymaps
    defaultKeymap = "emacs";

    history = {
      size = 50000;
      save = 50000;
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
    };

    initContent = builtins.readFile ./config.zsh
    + ''
      # nixos switch
      alias ns="sudo nixos-rebuild switch --flake ~/home/${username}/dotfiles#${hostname}"
      # home switch
      alias hs="sudo home-manager switch --flake ~/home/${username}/dotfiles#${hostname}"
    '';
  };
}
