#!/bin/bash

talosctl --nodes 192.168.1.203,192.168.1.204 shutdown
sleep 5m
talosctl --nodes 192.168.1.200,192.168.1.201,192.168.1.202 shutdown

#talosctl get nodes --nodes <one_of_your_control_plane_ips>
#NAME			STATUS	ROLES		AGE     VERSION
#192.168.1.203     	Ready	<none>   	5m30s   v1.29.x
#192.168.1.204     	Ready	<none>   	5m25s   v1.29.x
#<control_plane_node_1>	Ready	control-plane   10m     v1.29.x
#<control_plane_node_2>	Ready	control-plane   10m     v1.29.x
#<control_plane_node_3>	Ready	control-plane   10m     v1.29.x