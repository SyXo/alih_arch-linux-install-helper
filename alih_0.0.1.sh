#ALIH (Arch Linux Install Helper)
#By KlausDevWalker
#Version: 0.0.1
#Release Date: August 26th, 2019

#Set keyboard layout
loadkeys $br-abnt2

#Verify if actual boot mode is UEFI
ls /sys/firmware/efi/efivars

#Check network driver status
lspci -k

#Discover interface's name
ip link

#Activate network interface and check it for errors
ip link set $interface-name up && ip link

#Create config file for wpa_cli (wireless network)
echo "ctrl_interface=/run/wpa_supplicant" >> /etc/wpa_supplicant/wpa_supplicant.conf
echo "update_config=1" >> /etc/wpa_supplicant/wpa_supplicant.conf

#Encrypt the passphrase && use config file for wpa_cli (wireless network)
wpa_passphrase $MY-ESSID $MY-PASSPHRASE > /etc/wpa_supplicant/$MY-ESSID.conf
wpa_applicant -c /etc/wpa_supplicant/$MY-ESSID.conf -i $my-interface-name
wpa_applicant -B -c /etc/wpa_supplicant/$MY-ESSID.conf -i $my-interface-name

#Use wpa_cli interactive prompt to add a wireless network
wpa_cli
>scan
>scan_results
>add_network
>set_network $0 ssid "$MY-SSID"
>set_network $0 psk "$MY-PASSPHRASE"
>save_config
>quit

#Start and enable dhcp service to obtain an IP
systemctl start dhcpcd && systemctl enable dhcpcd 

#Ping an URL to test connection
ping -c $5 $google.com

#Turn on time syncronization with the internet and set timezone
timedatectl set-ntp true
timedatectl set-timezone $America/Sao_Paulo
timedatectl status

#Format and mount root partition
mkfs.ext4 /dev/sda$4
mkdir /mnt/sda$4 && mount /dev/sda$4/ /mnt/sda$4

#Mount EFI partition
mkdir /mnt/sda$1 && mount /dev/sda$1 /mnt/sda$1

#Edit /etc/pacman.d/mirrorlist for the best mirrors

#Generate fstab and check it for errors
genfstab -U /mnt >> /mnt/etc/fstab && cat /mnt/etc/fstab

#Change root to /mnt
arch-chroot /mnt

#Set time zone
ln -sf /usr/share/zoneinfo/$America/$Sao_Paulo /etc/localtime

#Generate /etc/adjtime
hwclock --systohc

#Uncomment eu_US.UTF-8 UTF-8 and other needed locales in /etc/locale.gen and generate them
locale-gen

#If keyboard layout was set, made it persistent
KEYMAP=$br-abnt2

#Create hostname file put your machine "name"
echo "$my-hostname" >> /etc/hostname

#Create and populate /etc/hosts
echo 127.0.0.1 localhost >> etc/hosts
echo ::1 localhost >> etc/hosts
echo 127.0.0.1 klaus-laptop.localdomain klaus-laptop >> etc/hosts

#Recreate the initramfs (optional)
mkinitcpio -p linux

#Set root password
passwd

#Install GRUB, efibootmgr, sudo and wpa_applicant (tree is optional)
pacman -S grub efibootmgr sudo wpa_supplicant tree

#Install GRUB in the chroot efi directory
grub-install --target=x86_64-efi --efi-directory=/mnt/boot/efi --bootloader-id=$Arch

#Install microcode for AMD OR Intel processors
pacman -S amd-ucode OR pacman -S intel-ucode

#Generate grub.cfg
grub-mkconfig -o /boot/grub/grub.cfg


#AFTER INSTALLATION

#Add a user and password
useradd -m $my-username
passwd

#Discover interface's name
ip link

#Activate network interface and check it for errors
ip link set $interface-name up && ip link

#Start and enable wpa_supplicant
systemctl start wpa_supplicant && systemctl enable wpa_supplicant

#Encrypt the passphrase && use config file for wpa_cli (wireless network)
wpa_passphrase $MY-ESSID $MY-PASSPHRASE > /etc/wpa_supplicant/$MY-ESSID.conf
wpa_applicant -c /etc/wpa_supplicant/$MY-ESSID.conf -i $my-interface-name
wpa_applicant -B -c /etc/wpa_supplicant/$MY-ESSID.conf -i $my-interface-name

#Start and enable dhcp service to obtain an IP
systemctl start dhcpcd && systemctl enable dhcpcd