#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

echo "Disabling service..";
systemctl stop ruuvi-prometheus.timer;
systemctl stop ruuvi-prometheus.service;

systemctl disable ruuvi-prometheus.timer;
systemctl disable ruuvi-prometheus.service;

rm /etc/systemd/system/ruuvi-prometheus.service;
rm /etc/systemd/system/ruuvi-prometheus.timer;
systemctl daemon-reload;
rm /etc/sudoers.d/ruuvi-sudoers;

echo "Delete user: ruuvi";
userdel -r ruuvi;

