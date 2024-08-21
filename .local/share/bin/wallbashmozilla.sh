#!/usr/bin/env sh


#// set variables

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
wallSet="${hydeThemeDir}/wall.set"
mozProfile=$(cat $HOME/.mozilla/firefox/profiles.ini | grep "Default=" | head -n 1 | awk -F '=' '{print $2}')
mozDir="$HOME/.mozilla/firefox/${mozProfile}"

mkdir -p $mozDir/chrome

ln -sf "$(readlink "${wallSet}")" $mozDir/chrome/wall.set