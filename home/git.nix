{ ... }:

{
  programs.git = {
    enable = true;

    userName = "Benedikt Hofirek";
    userEmail = "benedikthofirek@gmail.com";

    extraConfig = {
      init = {
        defaultBranch = "main";
      };

      core = {
        editor = "nvim";
        whitespace = "trailing-space,space-before-tab";
        preloadindex = true;
      };

      column = {
        ui = "auto";
      };

      branch = {
        sort = "-committerdate";
      };

      tag = {
        sort = "version:refname";
      };

      pull = {
        rebase = true;
      };

      push = {
        autoSetupRemote = true;
        default = "simple";
      };

      fetch = {
        prune = true;
        pruneTags = true;
      };

      diff = {
        algorithm = "histogram";
        renames = true;
      };

      help = {
        autocorrect = 10;
      };

      merge = {
        conflictstyle = "zdiff3";
      };

      rebase = {
        autoStash = true;
        autoSquash = true;
      };
    };
  };
}
