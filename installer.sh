#!/bin/bash

function prompt() {
	read -p "$1 [y/n] " -n 1 -r
}

function installifmissing() {
	if [ ! "$(pacman -Qi $* | grep error)" = "" ]
	then
		echo "Installing packages: $*"
		pacman -S $*
	fi
}

# defining global variables
THISDIR=$PWD
ESSENTIALS=$(cat essentials | tr "\n" " ")
SUCKLESSPROGRAMS=("dmenu surf")
AURPROGRAMS=$(cat aur | tr '\n' ' ')

# install packages provided in essential file
prompt "Install essential pacman packages?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	sudo pacman -Syu
	sudo pacman -S $ESSENTIALS 
fi

#install specified suckless programs
prompt "Install suckless programs?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	# install git and make if not installed already
	installifmissing git base-devel

	for sp in $SUCKLESSPROGRAMS; do
		cd /opt
		sudo git clone https://git.suckless.org/$sp
		sudo chmod +777 $sp
		cd $sp
		sudo chmod +777 *
		sudo make clean install
	done
fi

cd $THISDIR

prompt "Install my patched version of dwm and st?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	# install git and make if not installed already
	installifmissing git base-devel

	# install dwm
	cd /opt
	git clone https://github.com/AnejL/dwm
	cd dwm
	sudo make clean install

	# install st
	cd /opt
	git clone https://github.com/AnejL/st
	cd st
	sudo make clean install
fi

cd $THISDIR


#install configs and dotfiles
prompt "Install configs and dotfiles?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	# misc xorg configs (keyboard etc.)
	echo -e "\n\n> Copying xorg configs"
	sudo cp "configs/xorg/"* /etc/X11/xorg.conf.d/

	# install my dotfiles from git
	cd $HOME
	git clone https://github.com/AnejL/dotfiles
fi

# organize home folder and scripts and college files
prompt "Organize home folder?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	cd $HOME
	mkdir Documents Pictures Downloads Music Videos Backup .fonts .themes .icons

	# install my scripts TODO in universal location
	prompt "Download my script folder in Documents/Scripts?"

	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		cd $HOME/Documents
		mkdir Scripts
		cd Scripts
		git clone https://github.com/AnejL/Scripts
	fi

	# college files
	prompt "Download my college files?"

	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		cd Documents
		mkdir faks
		cd faks
		git clone https://github.com/AnejL/Faks
	fi
fi



prompt "Install yay and AUR packages?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	# if not installed install git and make
	installifmissing git base-devel
	
	# manually install yay aur helper
	cd /opt
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si

	# install the array of aur programs
	sudo yay -S $AURPROGRAMS
fi

# start cups printer service
sudo systemctl enable org.cups.cupsd.service
sudo systemctl start org.cups.cupsd.service

exit 0
