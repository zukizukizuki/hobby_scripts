# manual disk resize procedure for LVM-based RHEL7 VMs:
​
## 1: Resize the disk in VMware and take a snapshot
​
## 2: Identify the target disk (e.g. /dev/sda), partition number (e.g. 2 for /dev/sda2), LVM VG (e.g. vg00) and LVM LV (e.g. root) inside the VM
lvs && pvs && vgs
​
## 3: Set variables for the target
# EXAMPLES:
export DISK=/dev/sda
export PARTITIONNUMBER=2
export VG=vg00
export LV=root
export DEVICE=0:0:0:0 # this is the SCSI device path for the disk, e.g. 0:0:0:0 for the first, disk, 0:0:0:1 for the second, disk, etc.
​
## 4: Force the kernel to rescan disk's SCSI device:
echo 1 > /sys/class/scsi_disk/${DEVICE}/device/rescan
​
## 5: Delete and recreate target partition with new end block (-1s)
export STARTSECTOR=$(fdisk -u -l ${DISK} | grep ${PARTITION} | awk '{print $(NF-4)}')
​
parted ${DISK} -s "rm ${PARTITIONNUMBER}"
parted ${DISK} -s "mkpart primary ${STARTSECTOR}s -1s"
parted ${DISK} -s "set ${PARTITIONNUMBER} lvm on"
​
## 6: Tell kernel to re-read partition table without reboot
partx -u ${DISK}
​
## 7: Resize LVM PV and LV
pvresize ${DISK}${PARTITIONNUMBER}
lvextend -l +100%FREE -r /dev/${VG}/${LV}
​
# if lvextend with the -r flag fails for some reason, just leave it out and resize the filesystem with xfs_growfs or resize2fs afterwards ..
