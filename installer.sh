#!/bin/bash
# pacman install

thisdir=$PWD

read -p "Install essential pacman packages? [y/n] " -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]
then
	sudo pacman -Syu
	sudo pacman -S $(cat essentials | tr "\n" " ")
fi


#install suckless
read -p "Install suckless programs? [y/n] " -n 1 -r

sucklessprograms=("st dwm dmenu")

if [[ $REPLY =~ ^[Yy]$ ]]
then
	for sp in $sucklessprograms; do
		cd /opt
		sudo git clone https://git.suckless.org/$sp
		sudo chmod +777 $sp
		cd $sp
		sudo chmod +777 *
		sudo make clean install
	done
fi

cd $thisdir

#install configs
read -p "Install configs? [y/n] " -n 1 -r

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
	
	# -- fugly part -- #


	cd /opt/dwm
	sudo git apply $thisdir/configs/suckless/patches/dwm-fullgaps-6.2.diff

	# -- gonna add this later -- #
	
	
	for sp in $sucklessprograms; do
		cd $thisdir

		sudo cp "configs/suckless/$sp-config.h" /opt/$sp/config.h

		cd /opt/$sp
		sudo make clean install
	done
fi


read -p "Install AUR packages (with aura)? [y/n] " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
	aurprograms=("$(cat aur | tr '\n' ' ')")
	for ap in $aurprograms; do
		aura $ap
	done
fi



exit 0
