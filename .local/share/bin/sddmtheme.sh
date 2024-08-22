#!/bin/bash

scrDir=`dirname "$(realpath "$0")"`
source $scrDir/globalcontrol.sh

magick -density 256x256 -background transparent "${confDir}/hypr/face.svg" -define icon:auto-resize -colors 256 "$HOME/.face.icon"

sudo cp "${confDir}/sddm/themes/corners/theme.conf" "/usr/share/sddm/themes/corners/theme.conf"