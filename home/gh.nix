{ config, ... }: 

{
  programs.gh = {
    enable = true;
    settings = {
      editor = "nvim";
      git_protocol = "ssh";
    };
    gitCredentialHelper = {
      enable = true;
    };
    hosts = {
      "github.com" = {
        user = "BenediktHofirek";
        git_protocol = "ssh";
        oauth_token = config.sops-nix.placeholder.github_oauth_token;
      };
    };
  };
}
