#!/bin/bash -e

# Enable Cockpit service
systemctl enable cockpit.socket

echo "Cockpit enabled and will be available on port 9090"
