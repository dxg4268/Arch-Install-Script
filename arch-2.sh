echo
echo "---------------------------------------------------------------"
echo
echo "[+] Hello ! Welcome to Arch Linux Initial Configuration Wizard aka Part 2 of the Setup..."
echo "[+] Lets quickly setup Arch for You..."
echo
echo "---------------------------------------------------------------"
echo




#Time
echo "[+] Setting Up Date/Time and Locale... (Default Settings : INDIA)"
pacman -S ntp --noconfirm > /dev/null 2>&1
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
timedatectl set-ntp true
hwclock --systohc

echo
echo "---------------------------------------------------------------"
echo




#Locale
echo 'en_IN UTF-8' >> /etc/locale.gen
locale-gen
echo "LANG=en_IN.UTF-8" > /etc/locale.conf

echo
echo "---------------------------------------------------------------"
echo


#Hosts
echo "[+] Setting up Hosts on this Machine.."
#read -p "[-] Enter Host Name for this Device : " host
echo "dxg4268-eme732z" > /etc/hostname
echo "127.0.0.1		localhost" >> /etc/hosts
echo "::1		      localhost" >> /etc/hosts
echo "127.0.1.1		dxg4268-eme732z.localdomain	dxg4268-eme732z" >> /etc/hosts


echo
echo "---------------------------------------------------------------"
echo


#Bootloader
echo "[+] Now we will Install GRUB bootloader to boot up this device, Very Important..."

echo
echo "---------------------------------------------------------------"
echo
lsblk
echo
echo "---------------------------------------------------------------"
echo

sleep 2s

read -p "[-] Enter DISK on which GRUB is to be installed (eg. sda, sdb, vda)..." disk_grub
pacman -S os-prober ntfs-3g --noconfirm > /dev/null 2>&1
grub-install /dev/$disk_grub
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
echo
echo "---------------------------------------------------------------"
echo
grub-mkconfig -o /boot/grub/grub.cfg
echo
echo "---------------------------------------------------------------"
echo

#Extra packages
echo
echo
echo "[+] Some of the packages will be installed (xorg base-devel git unzip ,and some fonts - roboto etc.)"
#echo "[+] With AUR helper to enable AUR support..."
#pacman -S --needed git base-dev
echo
pacman -S wget --noconfirm 
#wget https://github.com/Jguer/yay/releases/download/v11.0.2/yay_11.0.2_x86_64.tar.gz
#pacman -U yay_11.0.2_x86_64.tar.gz


#Colors
echo 'include "/usr/share/nano/*.nanorc"' >> /etc/nanorc
sed -i 's/#Color/Color/g' /etc/pacman.conf

echo
echo
echo "---------------------------------------------------------------"
echo
pacman -S xorg xorg-xinit xfce4 xfce4-goodies papirus-icon-theme lightdm lightdm-gtk-greeter arc-gtk-theme archlinux-keyring base-devel zsh-syntax-highlighting zsh-autosuggestions starship zsh-history-substring-search pkgfile fzf pipewire pipewire-pulse pipewire-alsa git unzip ttf-liberation ttf-dejavu ttf-indic-otf zsh ufw ttf-roboto ttf-jetbrains-mono --noconfirm --needed
echo
echo "[*] Packages Installed Successfully..."
echo
echo "---------------------------------------------------------------"
echo
echo


echo "[+] This script ships with some themeing OPTION available as default as soon as you install a Desktop Environment..."
echo "[+] You need to apply them on your own..."
echo "    (Papirus Icons, Vimix Cursors)"

git clone https://github.com/vinceliuice/Vimix-cursors.git > /dev/null 2>&1
cd Vimix-cursors
chmod +x install.sh
./install.sh
cd ..
rm -rf Vimix-cursors

echo
echo "---------------------------------------------------------------"
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

echo "[+] Password for the root..."
passwd root


echo
echo "---------------------------------------------------------------"
echo

echo "[+] New User created !"
echo 
#yay -S pfetch --noconfirm > /dev/null 2>&1

#git clone https://github.com/dxg4268/Arch-Install-Script > /dev/null 2>&1
#cd Arch-Install#cp bashrc /home/aditya/.bashrc


echo
echo "---------------------------------------------------------------"
echo

#Chaotic AUR and imp AUR Packages
#pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
#pacman-key --lsign-key FBA220DFC880C036
#pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-'{keyring,mirrorlist}'.pkg.tar.zst'
#pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
#echo "[chaotic-aur]" >> /etc/pacman.conf
#echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
#pacman -Sy archlinux-appstream-data yay --noconfirm
echo
echo "---------------------------------------------------------------"
echo
echo "[+] Updating Repos and System..."
pacman -Syu

#enable service
echo "[+] Starting Services"
echo
systemctl enable ufw
systemctl enable NetworkManager
systemctl enable lightdm
echo
echo "---------------------------------------------------------------"
echo

echo "[+] Thank You for using this script, You may now remove Installation Drive and REBOOT :)"
