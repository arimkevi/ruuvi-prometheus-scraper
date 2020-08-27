#!/usr/bin/env python3

import time
import pprint
import signal
import sys
import json

from prometheus_client import Gauge, start_http_server
from ruuvitag_sensor.ruuvi import RuuviTagSensor

with open('/home/ruuvi/ruuvi-prometheus-scraper/config.json') as json_file:
    beacons = json.load(json_file)

temp_gauge = Gauge('ruuvi_temperature_c', 'Temperature in Celsius', ['location'])
humidity_gauge = Gauge('ruuvi_humidity_percent', 'Humidity %', ['location'])
pressure_gauge = Gauge('ruuvi_pressure_hpa', 'Air pressure hPa', ['location'])
battery_gauge = Gauge('ruuvi_battery_v', 'Battery V', ['location'])

def handle_data(data):
    [mac, sensor_data] = data
    beacon = beacons[mac]
    beacon['last_update'] = time.time()
    beacon['sensor_data'] = sensor_data
    location = beacon['name']
    temp_gauge.labels(location).set(sensor_data['temperature'])
    humidity_gauge.labels(location).set(sensor_data['humidity'] / 100.0)
    pressure_gauge.labels(location).set(sensor_data['pressure'])
    battery_gauge.labels(location).set(sensor_data['battery'] / 1000.0)

def sigint_handler(signal, frame):
    print("Collected data:")
    pprint.pprint(beacons)
    sys.exit(130)

if __name__ == '__main__':
    signal.signal(signal.SIGINT, sigint_handler)
    print("Starting HTTP server for Prometheus scraping")
    start_http_server(8000)

    print("Reading data from Ruuvi tags")
    RuuviTagSensor.get_datas(handle_data, beacons.keys())
