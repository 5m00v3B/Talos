#!/bin/bash

qm set 201 --delete scsi0
qm set 202 --delete scsi0
qm set 203 --delete scsi0
qm set 204 --delete scsi0
qm set 205 --delete scsi0

qm set 201 --scsi0 zfs_pool:vm-201-disk-0,size=64G
qm set 202 --scsi0 zfs_pool:vm-202-disk-0,size=64G
qm set 203 --scsi0 zfs_pool:vm-203-disk-0,size=64G
qm set 204 --scsi0 zfs_pool:vm-204-disk-0,size=64G
qm set 205 --scsi0 zfs_pool:vm-205-disk-0,size=64G
