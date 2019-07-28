#!/bin/bash
# pacman install

#
#
#
#
#	THIS PROGRAM USES DUMMY FUNCTIONS TO TEST ITERATIONS THROUGH ARRAYS AND SOME OTHER SHIT TOO
#
#
#
#


thisdir=$PWD

read -p "Install essential pacman packages? [y/n] " -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]
then
	#sudo pacman -Syu
	#sudo pacman -S $(echo .essentials)
	cat essentials
fi


#install suckless
read -p "Install suckless programs? [y/n] " -n 1 -r

sucklessprograms=("st dwm dmenu")

if [[ $REPLY =~ ^[Yy]$ ]]
then
	for sp in $sucklessprograms; do
		#cd /opt
		echo "/opt/$sp"
		#sudo git clone https://git.suckless.org/$sp
		#chmod +777 $sp
		#cd $sp
		#chmod +777 *
		#sudo make clean install
	done
fi

echo "ENDED SUCKLESS!"

cd $thisdir

#install configs
read -p "Install configs? [y/n] " -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo -e "\n\n> Copying xorg configs"
	cat "$PWD/configs/xorg/"*

	echo -e "\n\n> Copying vimrc"
	cat "$PWD/configs/vimrc"
	
	echo -e "\n\n> Copying bashrc"
	cat "$PWD/configs/bash/bashrc"

	echo -e "\n\n> Copying misc configs"
	ls -l "$PWD/configs/.config/"*

	echo "Copying over suckless configs"
	for sp in $sucklessprograms; do
		cd $thisdir

		echo "$sp"

		echo $(cat "configs/suckless/$sp-config.h" | head -10)

		cd /opt/$sp
		echo $PWD
		#sudo make clean install
	done
fi



exit 0
