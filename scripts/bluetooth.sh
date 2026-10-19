#!/usr/bin/env bash
if bluetoothctl show | grep -qi "PowerState:[[:space:]]*on"; then
    bluetoothctl power off
    notify-send "Bluetooth" "Powered Off" -i bluetooth-disabled
else
    bluetoothctl power on
    notify-send "Bluetooth" "Powered On" -i bluetooth-enabled
fi
