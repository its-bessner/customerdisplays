#!/bin/bash

export DISPLAY=:0
cd /home/baydev;
find -name "*_scrot.png" -mmin +60 -delete
scrot
filename="$(ls *scrot.png -t | head -n1)"
echo $filename;

# Create session
#answer=$(curl -c cookies.txt "https://www.bayerwaldhof.de/guestdisplays.html?session=1&id=$(cat id)")


 curl -b cookies.txt -v -F filename=screenshot  -F id_string=$(cat id) -F upload=@$filename "https://screenshot.its-bessner.de"

# sizes="$(xrandr | grep -e "^ " | cut -d " " -f 4)"
#
# echo "$sizes";
