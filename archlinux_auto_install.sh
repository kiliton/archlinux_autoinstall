#!/bin/bash
# partition, as there's noly 8GB to use
parted /dev/sda mklabel msdos 
parted /dev/sda mkpart primary 0% 90% 
parted /dev/sda mkpart primary 90% 100%

mkfs.ext4 /dev/sda1
mkswap /dev/sda2
swapon

# mount disk /dev/sda1 on folder /mnt 
mount /dev/sda1 /mnt

# update fstable after installing base packages 
genfstab -U /mnt >> /mnt/etc/fstab


# config the mirrorlist
#mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
echo "Server = http://mirrors.163.com/archlinux/\$repo/os/\$arch
Server = http://mirrors.cqu.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.cqu.edu.cn/archlinux/\$repo/os/\$arch
Server = http://mirror.lzu.edu.cn/archlinux/\$repo/os/\$arch
Server = http://mirrors.neusoft.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.neusoft.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux/\$repo/os/\$arch
Server = http://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch
Server = http://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.xjtu.edu.cn/archlinux/\$repo/os/\$arch
Server = http://mirrors.zju.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

# intall base packages
pacstrap /mnt base linux linux-firmware vim grub

echo "alias vi=vim" >> /mnt/etc/profile

# localize
echo "en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
zh_TW.UTF-8 UTF-8"  >> /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

# timezone
ln -sf /mnt/usr/share/zoneinfo/Asia/Shanghai /mnt/etc/localtime # or chroot /mnt ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
arch-chroot /mnt hwclock --systohc

# networkecho "myhostname" >> /etc/hostname
arch-chroot /mnt echo "127.0.0.1    myhostname.localdomain    myhostname" >> /etc/hosts


arch-chroot /mnt grub-install --target=i386-pc /dev/sda
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

# chroot /mnt passwd

# umount /mnt

# before finishing the script, there should not be any reboot or poweroff
# reboot