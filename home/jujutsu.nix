{ ... }:

{
  programs.jujutsu = {
    enable = true;

    settings = {
      user = {
        name = "Benedikt Hofirek";
        email = "benedikthofirek@gmail.com";
      };

      ui = {
        editor = "nvim";
        default-command = "log";
        diff-editor = ":builtin";
        conflict-marker-style = "snapshot";
        bookmark-list-sort-keys = [ "author-date" ];
      };

      experimental-advance-branches = {
        enabled-branches = [ "glob:*" ];
        disabled-branches = [
          "develop"
          "main"
          "master"
        ];
      };

      remotes = {
        origin = {
          auto-track-bookmarks = "glob:*";
        };
      };

    };
  };
}
