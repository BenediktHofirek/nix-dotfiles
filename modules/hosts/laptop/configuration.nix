{ self, inputs, ... }: {

  flake.nixosModules.laptopModule = { pkgs, lib, config, ... }: {
    imports = [
      self.nixosModules.laptopHardware
      self.nixosModules.niri
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nixpkgs.config.allowUnfree = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "laptop";
    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Prague";

    users.users.hero = {
      isNormalUser = true;

      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "audio"
      ];

      shell = pkgs.bashInteractive;

      initialPassword = "password";
    };

    environment.systemPackages = with pkgs; [
      git
      vim
      nano
      wget
      curl
      kitty
    ];

    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.displayManager.defaultSession = "niri";
    services.displayManager.autoLogin = {
      enable = true;
      user = "hero";
    };

    programs.xwayland.enable = true;
    programs.niri.enable = true;

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.graphics.enable = true;
    hardware.bluetooth.enable = true;
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

    virtualisation.vmVariant = {
      services.xserver.videoDrivers = lib.mkForce [ "modesetting" ];

      services.openssh.enable = true;
      services.openssh.settings.PasswordAuthentication = true;

      virtualisation = {
        memorySize = 4096;
        cores = 4;
        qemu.options = [
          "-device virtio-vga-gl"
          "-display gtk,gl=on"
        ];
        forwardPorts = [
          { from = "host"; host.port = 2222; guest.port = 22; }
        ];
      };

    };

    system.stateVersion = "26.05";
    home-manager.users.hero = self.homeModules.heroModule;
  };

}


