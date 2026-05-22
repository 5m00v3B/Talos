#!/bin/bash

#########################################################################################
stop_vm(){
	echo "Stopping VMs: "
	
	ssh root@pve02 <<-EOF
		qm stop 201
		EOF
	ssh root@pve03 <<-EOF
		qm stop 202
		EOF
	ssh root@pve02 <<-EOF
		qm stop 203	
		EOF
	ssh root@pve02 <<-EOF
		qm stop 204
		EOF
	ssh root@pve03 <<-EOF
		qm stop 205
		EOF
}

#########################################################################################
remove_disk(){
	echo "Removing Disks: "

	ssh root@pve02 <<-EOF
		qm set 201 --delete scsi0
		EOF
	ssh root@pve03 <<-EOF
		qm set 202 --delete scsi0
		EOF
	ssh root@pve02 <<-EOF
		qm set 203 --delete scsi0
		EOF
	ssh root@pve02 <<-EOF
		qm set 204 --delete scsi0
		EOF
	ssh root@pve03 <<-EOF
		qm set 205 --delete scsi0
		EOF
}

#########################################################################################
delete_disk(){
	echo "Deleting Disks: "

	ssh root@pve02 <<-EOF
		qm set 201 --delete unused0
		EOF
	ssh root@pve03 <<-EOF
		qm set 202 --delete unused0
		EOF
	ssh root@pve02 <<-EOF
		qm set 203 --delete unused0
		EOF
	ssh root@pve02 <<-EOF
		qm set 204 --delete unused0
		EOF
	ssh root@pve03 <<-EOF
		qm set 205 --delete unused0
		EOF
}

#########################################################################################
create_disk(){
	echo "Creating Disks: "

	ssh root@pve02 <<-EOF
		qm set 201 --scsi0 zfs_pool:64,cache=writethrough
		EOF
	ssh root@pve03 <<-EOF
		qm set 202 --scsi0 zfs_pool:vm-202-disk-0,cache=writethrough,size=64G
		EOF
	ssh root@pve02 <<-EOF
		qm set 203 --scsi0 zfs_pool:vm-203-disk-0,cache=writethrough,size=64G
		EOF
	ssh root@pve02 <<-EOF
		qm set 204 --scsi0 zfs_pool:vm-204-disk-0,cache=writethrough,size=64G
		EOF
	ssh root@pve03 <<-EOF
		qm set 205 --scsi0 zfs_pool:vm-205-disk-0,cache=writethrough,size=64G
		EOF
}

#########################################################################################
boot_order(){
	echo "Setting Boot Order: "

	ssh root@pve02 <<-EOF
		qm set 201 --boot order="scsi0;ide2"
		EOF
	ssh root@pve03 <<-EOF
		qm set 202 --boot order="scsi0;ide2"
		EOF
	ssh root@pve02 <<-EOF
		qm set 203 --boot order="scsi0;ide2"
		EOF
	ssh root@pve02 <<-EOF
		qm set 204 --boot order="scsi0;ide2"
		EOF
	ssh root@pve03 <<-EOF
		qm set 205 --boot order="scsi0;ide2"
		EOF
}

#########################################################################################
start_vm(){
	echo "Starting VMs: "
	
	ssh root@pve02 <<-EOF
		qm start 201
		EOF
	ssh root@pve03 <<-EOF
		qm start 202
		EOF
	ssh root@pve02 <<-EOF
		qm start 203
		EOF
	ssh root@pve02 <<-EOF
		qm start 204
		EOF
	ssh root@pve03 <<-EOF
		qm start 205
		EOF
}

#########################################################################################

stop_vm
remove_disk
delete_disk
#sleep 600
create_disk
boot_order
#start_vm
