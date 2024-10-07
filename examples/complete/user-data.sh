#!/bin/bash

### Mountig ebs volume

# Specify the target directory where you want to mount the devices
mount_point="/data"

# Device to skip
device_to_skip="xvda"

# Filesystem type
filesystem_type="ext4"  # Change this to the appropriate filesystem type

# Create the mount point directory if it doesn't exist
sudo mkdir -p "$mount_point"

# Use lsblk to list block devices, filter by type "disk" (whole disks)
# and exclude read-only filesystems (ro)
block_devices=$(lsblk -o NAME,TYPE,RO -r -n | awk '$2 == "disk" && $3 == "0" {print $1}')

# Iterate through the block devices, skip the specified device, and attempt to mount the rest
for device in $block_devices; do
    if [ "$device" != "$device_to_skip" ]; then
        echo "Mounting $device at $mount_point/$device"
        sudo mkdir -p "$mount_point/$device"
        sudo mkfs -t "$filesystem_type" "/dev/$device"  # Format the device with the specified filesystem
        sudo mount "/dev/$device" "$mount_point/$device"
        if [ $? -eq 0 ]; then
            echo "Mounting successful."
        else
            echo "Failed to mount $device."
        fi
    else
        echo "Skipping $device."
    fi
done
echo "Mounting complete."
