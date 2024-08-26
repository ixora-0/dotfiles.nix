{ config, pkgs, lib, ... }:
let
  p = pkgs.writeScriptBin "chargeupto" ''
    echo ''${0:-100} > /sys/class/power_supply/BAT?/charge_control_end_threshold
  '';
  cfg = config.hardware.asus.battery;
in

{
  options.hardware.asus.battery = {
    chargeUpTo = lib.mkOption {
      description = "Maximum level of charge for your battery, as a percentage.";
      default = 100;
      type = lib.types.int;
    };
    enableChargeUpToScript = lib.mkOption {
      description = "Whether to add chargeupto to environment.systemPackages. `chargeupto 75` temporarily sets the charge limit to 75%.";
      default = true;
      type = lib.types.bool;
    };
  };
  config = {
    environment.systemPackages = lib.mkIf cfg.enableChargeUpToScript [ p ];
    systemd.services.battery-charge-threshold = {
      wantedBy = [ "local-fs.target" "suspend.target" ];
      after = [ "local-fs.target" "suspend.target" ];
      description = "Set the battery charge threshold to ${toString cfg.chargeUpTo}%";
      startLimitBurst = 5;
      startLimitIntervalSec = 1;
      serviceConfig = {
        Type = "oneshot";
        Restart = "on-failure";
        ExecStart = "${pkgs.runtimeShell} -c 'echo ${toString cfg.chargeUpTo} > /sys/class/power_supply/BAT?/charge_control_end_threshold'";
      };
    };
  };
}
