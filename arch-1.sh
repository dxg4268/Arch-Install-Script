#Refresh mirrors

echo 
echo "Welcome to Arch Linux Installation (made by AdityaSharma from India)..."
echo "This script will guide you through the Installation process of Arch..."

echo
echo "[+] Updating MirrorList and Pacman Databases..."
reflector --verbose -c "India" --sort rate > /etc/pacman.d/mirrorlist
pacman -Syy > /dev/null 2>&1
echo
echo
echo "[+] All Package Databases were updated !"
echo
echo

lsblk

read -p "Enter Disk on which Arch is to be installed (eg. sda, vda, sdb): " disk_arch

echo "[!] Warning ! please refer to ArchWiki and do not format your essential data..."
echo
sleep 1s

echo "[+] Launching CFDisk Utility for disk management"
sleep 2s
cfdisk /dev/$disk_arch

 
echo "--------------------------------------------------------"
echo

lsblk

echo
echo "--------------------------------------------------------"
echo

read -p "Enter drive ID from above for Root Install (eg. sda1, vda1) : " root_disk
echo
read -p "Enter drive ID from above for SWAP space (eg. sda1, vda1) : " swap_disk
echo
echo
echo " [+] 3 Subvolumes (@, @home, @) on /dev/$root_disk will be created."
echo " [+] /dev/$swap_disk would be used as SWAP."
#Disks
mkfs.btrfs /dev/$root_disk -f > /dev/null 2>&1
mkswap /dev/$swap_disk > /dev/null 2>&1
swapon /dev/$swap_disk > /dev/null 2>&1
mount /dev/$root_disk /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@var
umount /mnt
mount -o noatime,compress=zstd,discard=async,subvol=@ /dev/$root_disk /mnt
mkdir /mnt/home
mkdir /mnt/var
mount -o noatime,compress=zstd,discard=async,subvol=@home /dev/$root_disk /mnt/home
mount -o noatime,compress=zstd,discard=async,subvol=@var /dev/$root_disk /mnt/var

echo 
echo "--------------------------------------------------------"
echo

lsblk

echo
echo "--------------------------------------------------------"
echo

sleep 2s
Base_Install=(base linux-lts linux-firmware sudo nano vi vim intel-ucode btrfs-progs networkmanager grub grub-btrfs)

echo "[!] This script will install some most important packages so that this computer can be used after FIRST "
echo "    reboot {base linux-zen linux-firmware sudo nano vi vim Network Manager}"
echo 
#echo "[*] If you want to install additional packages, please specify..."

#echo
#echo "[*] Example, you want to install HTOP with some other packages, Enter a package name and hit enter,"
#echo "    again type the package and hit enter. "

#echo
#echo "[*] Enter package name one by one as specified above, Maximum Packages = 10"
#Install Base System
echo
echo
echo "[+] Installing Packages to the new root, this might take some time depending the Internet speed."
pacstrap /mnt base linux-lts linux-firmware sudo nano vi vim intel-ucode btrfs-progs networkmanager grub grub-btrfs
echo
echo


#Generate fstab
echo "[+] Generating FSTAB..."
genfstab -U -p /mnt >> /mnt/etc/fstab

echo
echo
echo "[+] Thank You For Using this Installation Script..."
echo "[+] This script only installs some basic utilies , you may need to run Arch Install Part 2 (arch-2.sh)"


