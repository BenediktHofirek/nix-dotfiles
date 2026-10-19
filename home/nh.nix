{ config, ... }:

{
  programs.nh =  {
	enable = true;
	flake = "${config.home.homeDirectory}/dotfiles";
	homeFlake = "${config.home.homeDirectory}/dotfiles#laptop";

	clean =  {
		enable = true;
		extraArgs = "--keep-since 7d --keep 5";
	};
  };
}
