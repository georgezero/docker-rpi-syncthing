#!/bin/bash

docker run --rm -p 22000:22000  -p 21027:21027/udp -p 8384:8384 -v ~/src/syncthing/config:/syncthing/config -v ~/src/syncthing/data:/syncthing/data --name syncthing georgezero/rpi-syncthing
