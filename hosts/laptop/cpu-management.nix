{ pkgs, ... }:

{
  powerManagement = {
    cpuFreqGovernor = "powersave";
    cpufreq.max = 4500000; # 4500000 kHz = 4.5 GHz
  };

  # 2. Intel Undervolt Service Configuration
  services.undervolt = {
    enable = true;
    coreOffset = 0; # CPU & CPU Cache
    gpuOffset = 0; # GPU
    uncoreOffset = 0; # System Agent / Uncore
    analogioOffset = 0; # Analog I/O
    p2 = {
      limit = 100;
      window = 0.002; # Short power limit window
    };
    p1 = {
      limit = 85;
      window = 28.0; # Long power limit window
    };
    temp = -20; # Critical Temperature Offset
  };

  # 3. Declarative Systemd Service for Uncore Caps & EPP Tuning
  # Handles sysfs writes for uncore frequency and Energy Performance Preference (EPP)
  systemd.services.cpu-tuning = {
    description = "Apply Intel Uncore frequency limits and EPP preferences";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "cpu-tuning-script" ''
        # Cap Uncore (Ring Bus) to 4.0GHz (4000000 kHz)
        if [ -d "/sys/devices/system/cpu/intel_uncore_frequency/package_00_die_00" ]; then
            echo 4000000 > /sys/devices/system/cpu/intel_uncore_frequency/package_00_die_00/max_freq_khz
        fi

        # Set Energy Performance Preference (EPP) to 'balance_power'
        for epp in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
            [ -f "$epp" ] && echo "balance_power" > "$epp"
        done
      '';
    };
  };
}
