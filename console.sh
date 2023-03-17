#!/usr/bin/bash

# Grab TTYPath from service file
TTY=$(grep TTYPath $"/etc/systemd/system/minecraft@${PWD##*/}.service"| awk -F= '{print $2}')

# Open TTY
sudo conspy ${TTY:8}
