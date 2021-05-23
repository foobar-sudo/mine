#!/bin/bash
#echo "ARCH_EFI_PARTSIZE: $ARCH_EFI_PART_SIZE"
sleep 10
echo "Partitioning disk..."
_endPosition=$(sudo sgdisk -P --clear -E $ARCH_INSTALL_DISK)
_endAligned=$(( $_endPosition - ($_endPosition + 1) % ${ARCH_SECTOR_SIZE} ))
sudo sgdisk --zap-all $ARCH_INSTALL_DISK
sudo sgdisk --clear -a "${ARCH_SECTOR_SIZE}" \
       --new=0:0:+${ARCH_EFI_PART_SIZE}         --typecode=1:ef00   --change-name=1:$ARCH_EFI_PART \
       --new=0:0:+${ARCH_ROOT_PART_SIZE}         --typecode=2:8304   --change-name=2:$ARCH_ROOT_PART \
       --new=0:0:$_endAligned                            --typecode=3:8309   --change-name=3:$ARCH_SYSTEM_EPART \
         $ARCH_INSTALL_DISK
echo "Encrypting user partition..."
echo "temptemp" | sudo cryptsetup -q --sector-size "${ARCH_SECTOR_SIZE}" luksFormat /dev/disk/by-partlabel/$ARCH_SYSTEM_EPART
echo "Opening encrypted partiton..."
echo "temptemp" | sudo cryptsetup -q open /dev/disk/by-partlabel/$ARCH_SYSTEM_EPART $ARCH_SYSTEM_PART
echo "Creating filesystems..."
sudo mkfs.xfs -L ${ARCH_SYSTEM_PART} -f /dev/mapper/$ARCH_SYSTEM_PART
sudo mkfs.fat -F32 -n $ARCH_EFI_PART /dev/disk/by-partlabel/$ARCH_EFI_PART
sudo mkfs.btrfs --sectorsize "${ARCH_SECTOR_SIZE}" --force --label $ARCH_ROOT_PART /dev/disk/by-partlabel/$ARCH_ROOT_PART
sudo mkdir -p ${ARCH_DOWNLOADDIR}
echo "Mounting filesystems..."
echo "Mounting root BTRFS..."
sudo mount -t btrfs LABEL=$ARCH_ROOT_PART $ARCH_DOWNLOADDIR
echo "Creating directories for home and EFI..."
sudo mkdir ${ARCH_DOWNLOADDIR}/$ARCH_ESP
sudo mkdir $ARCH_DOWNLOADDIR/home
echo "Creating root subvolume..."
sudo btrfs subvolume create "${ARCH_DOWNLOADDIR}/@"
_archSubvolumes=(".snapshots" "opt" "root" "srv" "usr/local" "var")
echo "Creating directories for long subvolumes directories..."
echo "Creating other subvolumes..."
printf "%s\n" "${_archSubvolumes[@]}" | while read line; do { [[ $line =~ "/" ]] && sudo mkdir -p "${ARCH_DOWNLOADDIR}/@/$(dirname "$line")"; echo "Creating subvolume $line..."; sudo btrfs subvolume create "${ARCH_DOWNLOADDIR}/@/${line}"; }; done
echo "Unmounting everything..."
sudo umount -R $ARCH_DOWNLOADDIR
echo "Mountnig root subvolume..."
sudo mount -t btrfs -o $ARCH_MOUNT_BTRFS LABEL=$ARCH_ROOT_PART $ARCH_DOWNLOADDIR/
echo "Mounting other subvolumes..."
sudo printf "%s\n" "${_archSubvolumes[@]}" | while read line; do sudo mount -t btrfs -o subvol=@/$line,$ARCH_MOUNT_BTRFS LABEL=$ARCH_ROOT_PART $ARCH_DOWNLOADDIR/$line; done
echo "Mounting other partitions..."
sudo mount -t vfat -o $ARCH_MOUNT LABEL=$ARCH_EFI_PART $ARCH_DOWNLOADDIR/$ARCH_ESP
sudo mount -t xfs -o $ARCH_MOUNT LABEL=$ARCH_SYSTEM_PART $ARCH_DOWNLOADDIR/home
