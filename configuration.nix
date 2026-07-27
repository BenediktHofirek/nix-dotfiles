{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Prague";

  users.users.dev = {
    isNormalUser = true;

    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
    ];

    shell = pkgs.bashInteractive;

    initialPassword = "changeme";
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    nano
    wget
    curl
  ];

  services.displayManager.sddm.enable = true;

  services.displayManager.sddm.wayland.enable = true;

  services.displayManager.defaultSession = "hyprland";

  services.displayManager.autoLogin = {
    enable = true;
    user = "dev";
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;

    powerManagement.finegrained = false;

    open = false;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  system.stateVersion = "26.05";
}
