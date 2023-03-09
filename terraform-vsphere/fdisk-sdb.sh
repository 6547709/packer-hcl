#!/usr/bin/sudo /bin/bash
echo -e "o\nn\np\n1\n\n\nw" | fdisk /dev/sdb
sleep 5
pvcreate /dev/sdb1 -y
vgcreate data_vg /dev/sdb1  -y
lvcreate -l 100%VG -n lv_data data_vg  -y
mkfs.xfs /dev/data_vg/lv_data
mkdir -p $1
mount /dev/mapper/data_vg-lv_data $1
echo ""/dev/mapper/data_vg-lv_data"     $1         xfs defaults 0 0" >> /etc/fstab   

