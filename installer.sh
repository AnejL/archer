#!/bin/bash
# pacman install

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

if [[ $REPLY =~ ^[Yy]$ ]]
then
	sucklessprograms=st dwm dmenu

	for sp in $sucklessprograms; do
		cd /opt
		sudo git clone https://git.suckless.org/$sp
		cd $sp
		sudo make clean install
	done
fi

exit 0
