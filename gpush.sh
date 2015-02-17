#!/bin/bash

arg_1="$1"

if [ "$arg_1" = "" ]
then
	echo -n "	Enter a commit message: "
	read arg_1
fi
cd ~/Documents/SublimeFiles/master
git rm -r --cache .
git add .
git commit -m "$arg_1"
git push -u origin master
