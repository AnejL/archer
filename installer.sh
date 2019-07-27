#!/bin/bash
# pacman install

thisdir=$PWD

read -p "Install essential pacman packages? [y/n] " -n 1 -r
echo "\n$> "

if [[ $REPLY =~ ^[Yy]$ ]]
then
	sudo pacman -Syu
	sudo pacman -S $(echo .essentials)
fi


#install suckless
read -p "Install suckless programs? [y/n] " -n 1 -r
echo "\n$> "

sucklessprograms=st dwm dmenu

if [[ $REPLY =~ ^[Yy]$ ]]
then
	for sp in $sucklessprograms; do
		cd /opt
		sudo git clone https://git.suckless.org/$sp
		chmod +777 $sp
		cd $sp
		chmod +777 *
		sudo make clean install
	done
fi

cd $thisdir

#install configs
read -p "Install configs? [y/n] " -n 1 -r
echo "\n$> "

if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "\t> Copying xorg configs"
	sudo cp "configs/xorg/*" /etc/X11/xorg.conf.d/

	echo "\t> Copying bashrc"
	cp "configs/bash/bashrc" $HOME/.bashrc

	echo "\t> Copying misc configs"
	cp -r "configs/.config/*" $HOME/.config/

	echo "Copying over suckless configs"
	for sp in $sucklessprograms; do
		cd $thisdir

		if [[ $(grep "configs/suckless/patches/$sp*" | wc -l) -gt 0 ]]; then
			echo "$sp"
		fi
		
		sudo cp "configs/suckless/$sp-config.h" /opt/$sp/config.h

		cd /opt/$sp
		sudo make clean install
	done
fi



exit 0
