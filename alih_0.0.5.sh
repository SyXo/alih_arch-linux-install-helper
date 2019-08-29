#ALIH (Arch Linux Install Helper)
#By KlausDevWalker
#Version: 0.0.5
#Release Date: August 27th, 2019

#Set keyboard layout
loadkeys $br-abnt2

#Verify if actual boot mode is UEFI
efibootmgr

#Test connection to a known wireless connection (Control + C to stop)
wpa_supplicant -i $interfacename -c <(wpa_passphrase $my-ssid $my-passphrase)

#Fork it to the background to use it
wpa_supplicant -B -i $interfacename -c <(wpa_passphrase $my-ssid $my-passphrase)

#Start dhcpcd to get a IP
systemctl start dhcpcd

#Ping an URL to test connection
ping -c $5 $google.com

#Turn on time syncronization with the internet, set timezone and check time 
timedatectl set-ntp true
timedatectl set-timezone $America/$Sao_Paulo
timedatectl status

#Format and mount root partition on /mnt
mkfs.ext4 /dev/sda$4
mount /dev/sda$4/ /mnt

#Create directories for EFI and home (separated from root) partition
mkdir /mnt/boot && mkdir /mnt/boot/efi && mkdir /mnt/home

#Mount EFI and home (separated from root) partition
mount /dev/sda$1 /mnt/boot/efi && mount /dev/sda$3 /mnt/home

#Edit mirrorlist
nano /etc/pacman.d/mirrorlist

#Install base packages with pacstrap
pacstrap /mnt base

#Generate fstab and check it for errors
genfstab -U /mnt >> /mnt/etc/fstab && cat /mnt/etc/fstab

#Change root to /mnt
arch-chroot /mnt

#Set time zone
ln -sf /usr/share/zoneinfo/$America/$Sao_Paulo /etc/localtime

#Generate /etc/adjtime
hwclock --systohc

#Uncomment eu_US.UTF-8 UTF-8 and other needed locales in /etc/locale.gen and generate them
nano /etc/locale.gen
locale-gen

#If keyboard layout was set, made it persistent
KEYMAP=$br-abnt2 >> /etc/vconsole.conf

#Create hostname file and put your machine "name"
echo "$my-hostname" >> /etc/hostname

#Create and populate /etc/hosts
echo "127.0.0.1 localhost\n::1 localhost\n127.0.0.1 $my-hostname.localdomain $my-hostname\n" >> etc/hosts

#Recreate the initramfs (optional)
mkinitcpio -p linux

#Set root password
passwd

#Install GRUB, efibootmgr, sudo and wpa_applicant (tree is optional)
pacman -S grub efibootmgr sudo wpa_supplicant tree

#Install microcode for AMD OR Intel processor
pacman -S amd-ucode OR pacman -S intel-ucode

#Install GRUB in the chroot efi directory
grub-install --target=x86_64-efi --efi-directory=/mnt/boot/efi --bootloader-id=$Arch

#Creat grub directory and generate grub.cfg
mkdir /boot/grub && grub-mkconfig -o /boot/grub/grub.cfg

#Unmount all mounted devices and exit
umount -R /mnt

#Exit chroot enviroment
exit

#Reboot to finish installation
reboot



#AFTER INSTALLATION

#Login with root user (only user available in first boot)
root
$root-password

#If keyboard map reverted back to default (us), change and make it persistent
localectl set-keymap --no-convert $br-abnt2

#Add an user and a password for this account 
useradd -m $my-username
passwd $my-username

#Add that user to some important groups
usermod -a -G adm,wheel,sys,users,lp,network,power $my-username

#(Optionally) change default CLI text editor to nano
export EDITOR="nano"

#Enter 'visudo' command and add user below 'root ALL=(ALL) ALL' and save it
$my-username ALL=(ALL) ALL

#Reboot the system
reboot

#Enter user login credentials
> $my-username
> $my-user-password

#RIGHT NOW I COULDN'T PUT WIRELESS NETWORK TO WORK AFTER A RESTART.
#THE FOLLOWING WORKS WHILE THE SESSION IS RUNNING:
#
#Test connection to a known wireless connection (Control + C to stop)
sudo su -c 'wpa_supplicant -i wlp1s0 -c <(wpa_passphrase $my-ssid $my-passphrase)'
#
#Enable wireless connection to run in background
sudo su -c 'wpa_supplicant -i wlp1s0 -c <(wpa_passphrase $my-ssid $my-passphrase) -B'
#
#UNTIL I FIGURE IT OUT, I'll BE EDITING THE GUIDE WITH OTHER ESSENCIAL THINGS

