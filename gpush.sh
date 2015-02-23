#!/bin/bash

project="$1"

while [ "$project" != "master" ] && [ "$project" != "onePISD" ]
do
	echo -n "	Select project (master, onePISD): "
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
	git rm -r --cache .
	git add .
	git commit -m "$msg"
	git push -u origin master
elif [ "$project" == "onePISD" ]
then
	cd ~/Documents/SublimeFiles/onePISD
	git rm -r --cache .
	git add .
	git commit -m "$msg"
	git push -u origin master
fi
