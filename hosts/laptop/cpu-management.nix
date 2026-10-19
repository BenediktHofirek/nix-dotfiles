{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.intel.cpuTuning;
in
{
  options.hardware.intel.cpuTuning = {
    enable = lib.mkEnableOption "Intel CPU/uncore frequency tuning";

    uncoreMaxFreqKhz = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      example = 4000000;
      description = ''
        Maximum Intel uncore/ring-bus frequency in kHz.
        Applied to every detected package/die under
        /sys/devices/system/cpu/intel_uncore_frequency.
      '';
    };

    epp = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [
        "performance" "balance_performance" "balance_power" "power"
      ]);
      default = null;
      example = "balance_power";
      description = "Intel Energy Performance Preference for every CPU.";
    };

    requireUncoreInterface = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Fail the unit if the Intel uncore-frequency sysfs interface is missing.
        Useful when the cap is mandatory; leave false on heterogeneous hardware.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.intel-cpu-tuning = {
      description = "Apply Intel CPU EPP and uncore frequency limits";
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-modules-load.service" ];
      wants = [ "systemd-modules-load.service" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "intel-cpu-tuning" ''
          set -euo pipefail

          ${lib.optionalString (cfg.uncoreMaxFreqKhz != null) ''
            uncore_dir=/sys/devices/system/cpu/intel_uncore_frequency

            if [[ ! -d "$uncore_dir" ]]; then
              ${if cfg.requireUncoreInterface
                then ''echo "Intel uncore frequency sysfs interface not found" >&2; exit 1''
                else ''echo "Intel uncore frequency sysfs interface not found; skipping"''}
            else
              for die in "$uncore_dir"/package_*_die_*; do
                [[ -f "$die/max_freq_khz" ]] || continue
                echo ${toString cfg.uncoreMaxFreqKhz} > "$die/max_freq_khz"
              done
            fi
          ''}

          ${lib.optionalString (cfg.epp != null) ''
            shopt -s nullglob
            for epp in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
              echo ${cfg.epp} > "$epp"
            done
          ''}
        '';
      };
    };
  };
}
