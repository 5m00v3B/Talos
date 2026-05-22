#!/bin/bash

ssh root@pve02 <<-EOF
	qm stop 201
	qm destroy 201 --purge
	qm create 201 \
	  --balloon "0" \
	  --cores "2" \
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
	qm start 201

        qm stop 203
        qm destroy 203 --purge
	qm create 203 \
	  --balloon "0" \
	  --cores "2" \
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
	qm start 203
        
        qm stop 204
        qm destroy 204 --purge
	qm create 204 \
	  --balloon "0" \
	  --cores "2" \
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
	qm start 204
EOF

ssh root@pve03 <<-EOF
        qm stop 202
        qm destroy 202 --purge
	qm create 202 \
	  --balloon "0" \
	  --cores "2" \
	  --cpu "host" \
	  --machine "q35" \
	  --memory "2048" \
	  --name "talos-cn-02" \
	  --scsi0 "zfs_pool:64,cache=writethrough" \
	  --ide2 "local:iso/metal-amd64.iso,media=cdrom,size=326988K" \
	  --net0 "virtio=BC:24:11:50:54:DC,bridge=vmbr0,firewall=1" \
          --boot "order=scsi0;ide2" \
	  --numa "0" \
	  --ostype "l26" \
	  --scsihw "virtio-scsi-pci" \
	  --sockets "1" \
	  --startup "order=1" \
	  --tags "linux;vm"
	qm start 202

	qm stop 205
	qm destroy 205 --purge
	qm create 205 \
	  --balloon "0" \
	  --cores "2" \
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
	qm start 205
EOF

