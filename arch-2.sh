echo
echo"---------------------------------------------------------------"
echo
echo "[+] Hello ! Welcome to Arch Linux Initial Configuration Wizard aka Part 2 of the Setup..."
echo "[+] Lets quickly setup Arch for You..."
echo
echo"---------------------------------------------------------------"
echo




#Time
echo "[+] Setting Up Date/Time and Locale... (Default Settings : INDIA)"
pacman -S ntp --noconfirm > /dev/null 2>&1
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
timedatectl set-ntp true
hwclock --systohc

echo
echo"---------------------------------------------------------------"
echo




#Locale
echo 'en_IN UTF-8' >> /etc/locale.gen
locale-gen
echo "LANG=en_IN.UTF-8" > /etc/locale.conf

echo
echo"---------------------------------------------------------------"
echo


#Hosts
echo "[+] Setting up Hosts on this Machine.."
read -p "[-] Enter Host Name for this Device : " host
echo $host > /etc/hostname
echo "127.0.0.1		localhost" >> /etc/hosts
echo "::1		      localhost" >> /etc/hosts
echo "127.0.1.1		${host}.localdomain	    ${host}" >> /etc/hosts

echo
echo"---------------------------------------------------------------"
echo


#Bootloader
echo "[+] Now we will Install GRUB bootloader to boot up this device, Very Important..."

echo
echo"---------------------------------------------------------------"
echo
lsblk
echo
echo"---------------------------------------------------------------"
echo

sleep 2s

read -p "[-] Enter DISK on which GRUB is to be installed (eg. sda, sdb, vda)..." disk_grub
pacman -S grub grub-btrfs os-prober ntfs-3g --noconfirm > /dev/null 2>&1
grub-install $disk_grub
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

#Extra packages
echo "[+] Some of the packages will be installed (xorg base-devel git unzip ,and some fonts - roboto etc.)"
echo "[+] With AUR helper to enable AUR support..."
#pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git > /dev/null 2>&1
cd yay-bin
makepkg -si --needed --noconfirm  > /dev/null 2>&1
cd ..
rm -rf yay-bin


#Colors
echo 'include "/usr/share/nano/*.nanorc"' >> /etc/nanorc
sed -i 's/#Color/Color/g' /etc/pacman.conf


pacman -S xorg base-devel git unzip ttf-liberation ttf-dejavu ttf-indic-otf fish zsh ttf-roboto terminator --noconfirm
echo
echo"---------------------------------------------------------------"
echo

echo "[+] This script ships with some themeing OPTION available as default as soon as you install a Desktop Environment..."
echo "[+] You need to apply them on your own..."
echo "    (Papirus Icons, Vimix Cursors)"

pacman -S papirus-icon-theme octopi
echo "[+] Cloning Vimix Cursor REPO... "
git clone https://github.com/vinceliuice/Vimix-cursors.git > /dev/null 2>&1
cd Vimix-cursors
chmod +x install.sh
./install.sh
cd ..
rm -rf Vimix-cursors

echo
echo"---------------------------------------------------------------"
echo

echo "[+] Lets add a new Non-Root Account..."
echo
read -p "[-] Enter username for the new user : " name
echo 
#echo "-------------"
echo
echo "[*] Different Shells available on this device..."
echo
chsh -l
echo
read -p "[-] Select shell for the new user (support for - /bin/zsh): " shell

useradd -m -G wheel -s $shell $name
echo "[+] Now enter password for the new user..."
echo
passwd $name

echo
echo"---------------------------------------------------------------"
echo

echo "[+] New User created !"
echo 
yay -S pfetch --noconfirm > /dev/null 2>&1

git clone https://github.com/dxg4268/Arch-Install-Script > /dev/null 2>&1
cd Arch-Install-Script

if [[ ${shell} = "/bin/zsh" ]]
then
yay -S zsh-syntax-highlighting zsh-autosuggestions starship zsh-history-substring-search pkgfile find-the-command fzf --needed --noconfirm > /dev/null 2>&1
cp zshrc /home/$name/.zshrc
else
cp bashrc /home/$name/.bashrc
fi



#Chaotic AUR and imp AUR Packages
#pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
#pacman-key --lsign-key 3056513887B78AEB
#pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-'{keyring,mirrorlist}'.pkg.tar.zst'
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
#echo "[chaotic-aur]" >> /etc/pacman.conf
#echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
#pacman -Sy pamac-aur archlinux-appstream-data libpamac-aur yay --noconfirm

#enable service
#systemctl enable ufw
systemctl enable NetworkManager
#systemctl enable sddm

