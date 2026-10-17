{ ... }:

{
  programs.tmux = {
    enable = true;

    terminal = "tmux-256color";
    # Scrollback history
    historyLimit = 100000;
    # remove delay for exiting insert mode with ESC in Neovim
    escapeTime = 0;
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    aggressiveResize = true;
    focusEvents = true;

    extraConfig = builtins.readFile ./tmux.conf;
  };
}
