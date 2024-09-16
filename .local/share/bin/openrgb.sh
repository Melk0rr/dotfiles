#!/usr/bin/env sh

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"

mode="wallbash"
openrgbConf="${hydeThemeDir}/openrgb.conf"

export PYTHONPATH=$PYTHONPATH:${scrDir}

currWpp=$(readlink "${cacheDir}/wall.set")
wppName=$(basename "${currWpp}" | awk -F '.' '{print $1}')

themeProf="${hydeThemeDir}/openrgb.orp"
customCol="${cacheDir}/orp/${wppName}.conf"
openrgbCol="$HOME/.config/OpenRGB/colors.conf"

baseMainCol=$(grep "@color1" "${openrgbCol}" | awk -F ':' '{print $2}')
baseSecondCol=$(grep "@color4" "${openrgbCol}" | awk -F ':' '{print $2}')
baseThirdCol=$(grep "@color3" "${openrgbCol}" | awk -F ':' '{print $2}')
baseFourthCol=$(grep "@color2" "${openrgbCol}" | awk -F ':' '{print $2}')

Adjust_Wallbash () {
  satMainCol=$(python3 -c "import color; color.openrgb_color('#${baseMainCol}')")
  satSecondCol=$(python3 -c "import color; color.openrgb_color('#${baseSecondCol}')")
  satThirdCol=$(python3 -c "import color; color.openrgb_color('#${baseThirdCol}')")

  newSecondCol="${satSecondCol}"
  
  distance1=$(python3 -c "import color; color.hex_color_distance('#${satMainCol:1}', '#${satSecondCol:1}')")
  distance2=$(python3 -c "import color; color.hex_color_distance('#${satMainCol:1}', '#${satThirdCol:1}')")

  echo "${distance1} / ${distance2}"
  if [[ "${distance2}" > "${distance1}" ]] ; then
    newSecondCol="${satThirdCol}"
  fi

  sed -i "s/${baseMainCol}/${satMainCol:1}/g" "${openrgbCol}"
  sed -i "s/${baseSecondCol}/${newSecondCol:1}/g" "${openrgbCol}"
}

OpenRGB_Wallbash () {
  # If there is a custom profile : use it
  if [[ -f "${customCol}" ]] ; then
    col="${customCol}"
  
  else
    Adjust_Wallbash
    col="${openrgbCol}"
  fi

  openrgbCmd="openrgb"

  if [[ "${start}" == true ]] ; then
    openrgbCmd+=" --startminimized"
  fi

  i=0
  while read -r line ; do
    if [[ $line =~ ^# ]] ; then
      read line1
      openrgbCmd+=" -d ${line:2:1} -c ${line1} -m Direct"
    fi
    i=$((i+1));
  done < "$col"
  
  if [[ "${start}" == false ]] ; then
    openrgbCmd+=" -sp wallbash.orp"
  fi
  
  eval "$openrgbCmd"
}

OpenRGB_Start () {
  if [[ "${mode}" == "wallbash" ]] ; then
    OpenRGB_Wallbash

  else
    openrgb --profile theme.orp
  fi
}

ln -fs "${hydeThemeDir}/openrgb.orp" "${confDir}/OpenRGB/theme.orp"

if [[ -f "${openrgbConf}" ]] ; then
  mode=$(cat "${openrgbConf}" | awk -F '=' '{print $2}')
fi

# If mode is not wallbash and there is no theme profile nor custom profile for current wpp : set mode to wallbash
if [[ "${mode}" != "wallbash" && ! -f "${themeProf}" && ! -f "${customCol}" ]] ; then
  mode="wallbash"
fi

case "${1}" in
s|-s|--start)
  start=true
  OpenRGB_Start
  ;;
g|-g|--generate)
  start=false

  if [[ "${mode}" == "wallbash" ]] ; then
    OpenRGB_Wallbash

  else
    openrgb --profile theme.orp
  fi
  ;;
*)
  echo -e "openrgb.sh [action]"
  echo "s -s --start     :  start openrgb"
  echo "g -g --generate  :  generate color conf"
  exit 1
  ;;
esac