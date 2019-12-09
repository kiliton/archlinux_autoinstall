#!/bin/bash
# partition, as there's noly 8GB to use
parted /dev/sda mklabel msdos mkpart mkpart 0% 90% mkpart primary 10% 100%

mkfs.ext4 /dev/sda1
mkswap /dev/sda2
swapon

# mount disk /dev/sda2 on folder /mnt 
mount /dev/sda2 /mnt

# update 
fstabgenfstab -p /mnt >> /mnt/etc/fstab

# config the mirrorlist
#mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
echo "Server = http://mirrors.163.com/archlinux/$repo/os/$arch
Server = http://mirrors.cqu.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.cqu.edu.cn/archlinux/$repo/os/$arch
Server = http://mirror.lzu.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.neusoft.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.neusoft.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.xjtu.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.zju.edu.cn/archlinux/$repo/os/$arch" > /etc/pacman.d/mirrorlist

# intall base packages
pacstrap /mnt base base-develarch-chroot /mnt 

# localize
echo "en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
zh_TW.UTF-8 UTF-8"  >> /etc/locale.genlocale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# timezone
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc

# networkecho "myhostname" >> /etc/hostname
echo "127.0.0.1    myhostname.localdomain    myhostname" >> /etc/hosts

pacman -Syu
pacman -Sy vim grub echo "alias vi=vim" >> /etc/profile
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

passwd

exit

umount /mnt

reboot