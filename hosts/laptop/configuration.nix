{
  config,
  ...
}:
{

  services.xserver.videoDrivers = [ "nvidia" ];
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

  # Cpu configuration

  imports = [ ./cpu-management.nix ];

  powerManagement = {
    cpuFreqGovernor = "powersave";
    cpufreq.max = 4500000; # 4.5 GHz
  };

  hardware.intel.cpuTuning = {
    enable = true;
    uncoreMaxFreqKhz = 4000000; # 4.0 GHz ring bus / uncore cap
    epp = "balance_power";
    requireUncoreInterface = true;
  };

  services.undervolt = {
    enable = true;
    coreOffset = 0;
    gpuOffset = 0;
    uncoreOffset = 0;
    analogioOffset = 0;
    p2.limit = 100;
    p2.window = 0.002;
    p1.limit = 85;
    p1.window = 28.0;
    temp = -20;
  };
}
