docker-google-domains-ddns
============

This is a simple Docker container for running the [Google Domains](http://domains.google/) dynamic DNS update script. It will keep your domain.ddns.net DNS alias up-to-date as your home IP changes. 

It is heavily based on https://github.com/dragoncube/docker-google-domains-ddns, which is in turn based on David Coppit's work (https://github.com/coppit/docker-no-ip), since Google Domains DDN API is pretty much the same as No-IP's.

By default, the script runs every 30 minutes, which can be overriden via the `INTERVAL` environment variable.

Supports `amd64` and `arm`.

Usage
-----

Run:

`sudo docker run -v /etc/localtime:/etc/localtime -e USERNAME=<username> -e PASSWORD=<password> -e HOSTNAME=dyn.example.com -e INTERVAL=30m cwmr/google-domains-ddns`

To check the status, run `docker logs google-domains-ddns`.
