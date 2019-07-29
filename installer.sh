#!/bin/bash
# pacman install

function prompt() {
	read -p "$1 [y/n] " -n 1 -r
}

THISDIR=$PWD
ESSENTIALS=$(cat essentials | tr "\n" " ")
SUCKLESSPROGRAMS=("st dwm dmenu")
AURPROGRAMS=("$(cat aur | tr '\n' ' ')")

prompt "Install essential pacman packages?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	sudo pacman -Syu
	sudo pacman -S $ESSENTIALS 
fi

#install suckless
prompt "Install suckless programs?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
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

#install configs
prompt "Install configs?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo -e "\n\n> Copying xorg configs"
	sudo cp "configs/xorg/"* /etc/X11/xorg.conf.d/
	
	echo -e "\n\n> Copying vimrc"
	cp "configs/vimrc" $HOME/.vimrc

	echo -e "\n\n> Copying bashrc"
	cp "configs/bash/bashrc" $HOME/.bashrc

	echo -e "\n\n> Copying misc configs"
	cp -r "configs/.config/*" $HOME/.config/

	echo -e "Copying over suckless configs"
	
	# -- ugly part -- #

	cd /opt/dwm
	sudo git apply $THISDIR/configs/suckless/patches/dwm-fullgaps-6.2.diff

	# -- TODO apply patches automatically -- #
	
	
	for sp in $SUCKLESSPROGRAMS; do
		cd $THISDIR

		sudo cp "configs/suckless/$sp-config.h" /opt/$sp/config.h

		cd /opt/$sp
		sudo make clean install
	done
fi


prompt "Install AUR packages (with aura)?"

if [[ $REPLY =~ ^[Yy]$ ]]
then

	for ap in $AURPROGRAMS; do
		aura $ap
	done
fi

# start cups printer service
sudo systemctl enable org.cups.cupsd.service
sudo systemctl start org.cups.cupsd.service

exit 0
