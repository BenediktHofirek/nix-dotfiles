{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
    ];

    # Use fd for the Ctrl+T file picker.
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude .direnv --exclude result";

    # Use fd for the Alt+C directory picker.
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git --exclude node_modules --exclude .direnv --exclude result";
  };
}

