#!/bin/bash

# Helper functions 
#
# function for asking user something
function prompt() {
	read -p "$1 [y/n] " -n 1 -r
}

# checks if said packages are installed and installs them if they are missing
# be careful to check that packages exist as checking is not implemented
function installifmissing() {
	if [ ! $(pacman -Qi $* | grep error | wc -l) -gt 0 ]
	then
		echo "> Installing packages: $*"
		sudo pacman -S $*
	else
		echo "> Dependencies ok!"
	fi
}

# TODO add a function for specifying a custom destination folder

# defining global variables
THISDIR=$PWD
ESSENTIALS=$(cat essentials | tr "\n" " ")
# SUCKLESSPROGRAMS=("")
# SUCKLESSPROGRAMS=("dmenu surf")
AURPROGRAMS=$(cat aur | tr '\n' ' ')

# install packages provided in essential file
prompt "Install essential pacman packages?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	sudo pacman -Syu
	sudo pacman -S $ESSENTIALS 
fi

# install specified suckless programs (NOW DEPRECATED AS I USE MY OWN FORKS)
# prompt "Install suckless programs?"

# if [[ $REPLY =~ ^[Yy]$ ]]
# then
	# install git and make if not installed already
#	installifmissing git base-devel

#	for sp in $SUCKLESSPROGRAMS; do
		# cd /opt
		# sudo git clone https://git.suckless.org/$sp
		# sudo chmod +777 $sp
		# cd $sp
		# sudo chmod +777 *
		# sudo make clean install
	# done
# fi

cd $THISDIR

prompt "Install my patched version of suckless programs (dwm, st, dmenu)?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	# install git and make if not installed already
	installifmissing git libx11 make

	# install dwm
	cd /opt
	sudo git clone https://github.com/AnejL/dwm
	cd dwm
	sudo make clean install

	# install st
	cd /opt
	sudo git clone https://github.com/AnejL/st
	cd st
	sudo make clean install
	
	# install dmenu
	cd /opt
	sudo git clone https://github.com/AnejL/dmenu
	cd dmenu
	sudo make clean install
fi

cd $THISDIR

#install configs and dotfiles
prompt "Install xorg configs for trackpad, intel graphics and keyboard? (recommended only if you use a ThinkPad)"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo -e "\n\n> Copying xorg configs"
	sudo cp "configs/xorg/"* /etc/X11/xorg.conf.d/
fi

#install configs and dotfiles
prompt "Download my dotfiles to $HOME?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	installifmissing git
	# TODO what files are in conflict here? WC - use fetch --all + reset method
	cd $HOME
	rm .bashrc .bash_profile .bash_history .bash_logout
	git init
	git remote add origin https://github.com/AnejL/dotfiles
	git pull origin master
fi

# organize home folder and scripts and college files
prompt "Organize home folder (includes my Scripts and academic files which are private)?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	installifmissing git
	cd $HOME
	mkdir Documents Pictures Downloads Devel Music Videos Backup # .fonts .themes .icons

	prompt "Download my script folder in Documents/Scripts?"

	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		cd $HOME/Documents
		git clone https://github.com/AnejL/Scripts

		cd Scripts
		git clone https://github.com/AnejL/dbc
		cd dbc
		sudo make clean install
		
		cd ..
		git clone https://github.com/AnejL/archer
	fi

	# college files
	prompt "Download my college files?"

	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		cd $HOME/Documents
		mkdir Faks
		cd Faks
		git init
		git remote add origin https://github.com/AnejL/Faks
		git pull origin master
	fi
fi


prompt "Install yay and AUR packages?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	installifmissing git make
	
	# manually install yay aur helper
	cd /opt
	sudo git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si

	# install the array of aur programs
	yay -S $AURPROGRAMS
fi


prompt "Make pulseaudio bearable (if installed)?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	installifmissing pulseaudio

	cd $THISDIR
	echo -e "\n\n> Overwriting pulseaudio configs"
	sudo cp "configs/pulse/"* /etc/pulse/
fi

cd 

# start cups printer service
# sudo systemctl enable org.cups.cupsd.service
# sudo systemctl start org.cups.cupsd.service

echo -e "\nInstallation finished! Start xorg with startx"

exit 0
