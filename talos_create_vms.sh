#!/bin/bash

ssh root@pve02 <<-EOF
	qm stop 201
	sleep 5
	qm destroy 201 --purge
	sleep 5
	qm create 201 \
	  --balloon "0" \
	  --cores "1" \
	  --cpu "host" \
	  --machine "q35" \
	  --memory "2048" \
	  --name "talos-cn-01" \
	  --scsi0 "zfs_pool:64,cache=writethrough" \
	  --ide2 "local:iso/metal-amd64.iso,media=cdrom,size=326988K" \
	  --net0 "virtio=BC:24:11:C9:23:67,bridge=vmbr0,firewall=1" \
          --boot "order=scsi0;ide2" \
	  --numa "0" \
	  --onboot "1" \
	  --ostype "l26" \
	  --scsihw "virtio-scsi-pci" \
	  --sockets "1" \
	  --startup "order=1" \
	  --tags "linux;vm"
	sleep 5
	qm start 201
	sleep 10
        qm stop 203
        sleep 5
        qm destroy 203 --purge
	sleep 5
	qm create 203 \
	  --balloon "0" \
	  --cores "1" \
	  --cpu "host" \
	  --machine "q35" \
	  --memory "2048" \
	  --name "talos-cn-03" \
	  --scsi0 "zfs_pool:64,cache=writethrough" \
	  --ide2 "local:iso/metal-amd64.iso,media=cdrom,size=326988K" \
	  --net0 "virtio=BC:24:11:5D:5B:A0,bridge=vmbr0,firewall=1" \
          --boot "order=scsi0;ide2" \
	  --numa "0" \
	  --onboot "1" \
	  --ostype "l26" \
	  --scsihw "virtio-scsi-pci" \
	  --sockets "1" \
	  --startup "order=2,up=30" \
	  --tags "linux;vm"
	sleep 5
	qm start 203
        sleep 10
        qm stop 204
        sleep 5
        qm destroy 204 --purge
	sleep 5
	qm create 204 \
	  --balloon "0" \
	  --cores "1" \
	  --cpu "host" \
	  --machine "q35" \
	  --memory "2048" \
	  --name "talos-wn-01" \
	  --scsi0 "zfs_pool:64,cache=writethrough" \
	  --ide2 "local:iso/metal-amd64.iso,media=cdrom,size=326988K" \
	  --net0 "virtio=BC:24:11:4F:71:18,bridge=vmbr0,firewall=1" \
          --boot "order=scsi0;ide2" \
	  --numa "0" \
	  --onboot "1" \
	  --ostype "l26" \
	  --scsihw "virtio-scsi-pci" \
	  --sockets "1" \
	  --startup "order=3,up=60" \
	  --tags "linux;vm"
	sleep 5
	qm start 204
	sleep 10
EOF

sleep 5

ssh root@pve03 <<-EOF
        qm stop 202
        sleep 5
        qm destroy 202 --purge
	sleep 5
	qm create 202 \
	  --balloon "0" \
	  --cores "1" \
	  --cpu "host" \
	  --machine "q35" \
	  --memory "2048" \
	  --name "talos-cn-02" \
	  --scsi0 "zfs_pool:64,cache=writethrough" \
	  --ide2 "local:iso/metal-amd64.iso,media=cdrom,size=326988K" \
	  --net0 "virtio=BC:24:11:50:54:DC,bridge=vmbr0,firewall=1" \
          --boot "order=scsi0;ide2" \
	  --numa "0" \
	  --onboot "1" \
	  --ostype "l26" \
	  --scsihw "virtio-scsi-pci" \
	  --sockets "1" \
	  --startup "order=1" \
	  --tags "linux;vm"
	sleep 5
	qm start 202
	sleep 10
	qm stop 205
	sleep 5
	qm destroy 205 --purge
	sleep 5
	qm create 205 \
	  --balloon "0" \
	  --cores "1" \
	  --cpu "host" \
	  --machine "q35" \
	  --memory "2048" \
	  --name "talos-wn-02" \
	  --scsi0 "zfs_pool:64,cache=writethrough" \
	  --ide2 "local:iso/metal-amd64.iso,media=cdrom,size=326988K" \
	  --net0 "virtio=BC:24:11:77:DC:FE,bridge=vmbr0,firewall=1" \
	  --boot "order=scsi0;ide2" \
	  --numa "0" \
	  --onboot "1" \
	  --ostype "l26" \
	  --scsihw "virtio-scsi-pci" \
	  --sockets "1" \
	  --startup "order=2,up=60" \
	  --tags "linux;vm"
	sleep 5
	qm start 205
	sleep 5
EOF

sleep 120
