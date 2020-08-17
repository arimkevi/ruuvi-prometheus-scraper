# Ruuvi Prometheus scraper

Installer and setup update from [Hilzus ruuvi-prometheus-scraper][hilzus-repo]. 

Collects weather data from [Ruuvi tags][ruuvi-tag] running the [official
firmware][fw] for consumption by [Prometheus][prometheus].

You also need to configure Prometheus to scrape data from
the app from the address `http://localhost:8000/metrics`. Example config in deploy/prometheus.yml.

Install script installs required dependencies, creates ruuvi user, installs env and seutps systemd service.

Uninstall script removes all above.

## Grafana dashboard

[Import from grafana][grafana]

or 

import directly from file: grafana-dash.json

## Install

Run:

```curl -fsSL "https://raw.githubusercontent.com/arimkevi/ruuvi-prometheus-scraper/master/install.sh" | sudo bash```

Modify /home/ruuvi/ruuvi-prometheus-scraper/config.json with your RuuviTags

then run:

```sudo systemctl restart ruuvi-prometheus```

[hilzus-repo]: https://github.com/Hilzu/ruuvi-prometheus-scraper
[ruuvi-tag]: https://tag.ruuvi.com/
[fw]: https://lab.ruuvi.com/ruuvitag-fw/
[prometheus]: https://prometheus.io/
[grafana]: https://grafana.com/grafana/dashboards/12838
