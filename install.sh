#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

echo "Installing ruuvi prometheus scraper";

echo "Installing packages..";
apt -y install virtualenv python3 python3-pip bluez bluez-hcidump;

echo "Creating user..";
useradd -m ruuvi ;

echo "Downloading repo..";
curl -sL "https://github.com/arimkevi/ruuvi-prometheus-scraper/archive/master.zip" > "/tmp/ruuvi_prometheus.zip";
unzip -qq -o "/tmp/ruuvi_prometheus.zip" -d "/home/ruuvi";
mv /home/ruuvi/ruuvi-prometheus-scraper-master /home/ruuvi/ruuvi-prometheus-scraper
chown -R ruuvi:ruuvi /home/ruuvi/ruuvi-prometheus-scraper/
rm /tmp/ruuvi_prometheus.zip;

echo "Installing venv..";
runuser -l ruuvi -c 'cd /home/ruuvi/ruuvi-prometheus-scraper; virtualenv venv -p python3;';

echo "Istalling python requirements to venv..";
runuser -l ruuvi -c 'source /home/ruuvi/ruuvi-prometheus-scraper/venv/bin/activate; pip install -r /home/ruuvi/ruuvi-prometheus-scraper/requirements.txt;';

echo "Setting up service.."
mv "/home/ruuvi/ruuvi-prometheus-scraper/deploy/ruuvi-prometheus.service" "/etc/systemd/system/";
mv "/home/ruuvi/ruuvi-prometheus-scraper/deploy/ruuvi-prometheus.timer" "/etc/systemd/system/";
cp /home/ruuvi/ruuvi-prometheus-scraper/deploy/ruuvi-sudoers /etc/sudoers.d/
systemctl stop ruuvi-prometheus.timer;
systemctl disable ruuvi-prometheus.timer;

systemctl daemon-reload
systemctl enable ruuvi-prometheus.timer;
systemctl start ruuvi-prometheus.timer;