#!/bin/bash

project="$1"

while [ "$project" != "master" ] && [ "$project" != "onePISD" ] && [ "$project" != "transient" ] && [ "$project" != "here" ]
do
	echo -n "	Select project (master, onePISD, transient) or push in current directory (here): "
	read project
done

msg=""

while [ "$msg" == "" ]
do
	echo -n "	Enter a commit message: "
	read msg
done

git config --global user.name "Enrico Borba"
git config --global user.email enricozb@gmail.com

if [ "$project" == "master" ]
then 
	cd ~/Documents/SublimeFiles/master

elif [ "$project" == "onePISD" ]
then
	cd ~/Documents/SublimeFiles/onePISD
	
elif [ "$project" == "transient" ]
then 
	cd ~/Documents/SublimeFiles/transient
fi

git rm -r --cache .
git add .
git commit -m "$msg"
git push -u origin master
