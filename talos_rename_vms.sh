#1/bin/bash

talosctl patch mc --nodes 192.168.1.201 --patch '[{"op": "replace", "path": "/machine/network/hostname", "value": "talos-cn-01"}]'
talosctl patch mc --nodes 192.168.1.202 --patch '[{"op": "replace", "path": "/machine/network/hostname", "value": "talos-cn-02"}]'
talosctl patch mc --nodes 192.168.1.203 --patch '[{"op": "replace", "path": "/machine/network/hostname", "value": "talos-cn-03"}]'
talosctl patch mc --nodes 192.168.1.204 --patch '[{"op": "replace", "path": "/machine/network/hostname", "value": "talos-wn-01"}]'
talosctl patch mc --nodes 192.168.1.205 --patch '[{"op": "replace", "path": "/machine/network/hostname", "value": "talos-wn-02"}]'
sleep 10

talosctl reboot --nodes 192.168.1.201
sleep 10
talosctl reboot --nodes 192.168.1.202
sleep 10
talosctl reboot --nodes 192.168.1.203
sleep 10
talosctl reboot --nodes 192.168.1.204
sleep 10
talosctl reboot --nodes 192.168.1.205
sleep 10



