{
  inputs,
  pkgs,
  config,
  username,
  hostname,
  ...
}:
{

  imports = [
    # ./cpu-management.nix
  ];

  system.stateVersion = "26.05";

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelModules = [
    "i2c-dev"
  ];

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Prague";

  services.xserver.xkb = {
    layout = "us";
    variant = ""; # Leave empty for standard US layout
  };

  nix = {
    settings = {
      auto-optimise-store = true; # Hard-link identical store files
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    # GC handled with nh
    # gc = {
    #  automatic = true;
    #  dates = "weekly"; # Runs weekly (uses systemd timer)
    #  options = "--delete-older-than 14d"; # Keeps generations from the last 14 days
    #};
  };

  # Set keyboard layout for Console / TTY (non-graphical terminal)
  console.keyMap = "us";

  users.users.${username} = {
    isNormalUser = true;

    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "i2c"
    ];

    shell = pkgs.bashInteractive;

    initialPassword = username;
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.displayManager.defaultSession = "hyprland";
  services.displayManager.autoLogin = {
    enable = false;
    user = username;
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true;
  };

  # Screensharing, notifications
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };

  hardware.bluetooth.enable = true;
  hardware.i2c.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
