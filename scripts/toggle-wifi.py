#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.10"
# dependencies = [
#     "tplinkrouterc6u",
# ]
# ///

import subprocess
from tplinkrouterc6u import TplinkRouterProvider, Connection

ROUTER_IP = 'http://192.168.1.1'
PASSWORD = 'test'

client = TplinkRouterProvider.get_client(ROUTER_IP, PASSWORD)

client.authorize()
status = client.get_status()

currently_on = status.wifi_2g_enable
new_state = not currently_on

client.set_wifi(Connection.HOST_2G, new_state)

state_str = "ON" if new_state else "OFF"
print(f"2.4GHz Wi-Fi turned {state_str}")

subprocess.run(['notify-send', f'2.4GHz {state_str}', '--icon=network-wireless'])
