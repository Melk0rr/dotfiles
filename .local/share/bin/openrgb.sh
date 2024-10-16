#!/usr/bin/env sh

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"

# devices=($( openrgb -l | grep '^[0-9]: ' ))
mapfile -t devices < <(openrgb -l | grep '^[0-9]: ')

mode="wallbash"
openrgbConf="${hydeThemeDir}/openrgb.conf"

currWpp=$(readlink "${cacheDir}/wall.set")
wppName=$(basename "${currWpp}" | awk -F '.' '{print $1}')

themeProf="${hydeThemeDir}/openrgb.orp"
customCol="${cacheDir}/orp/${wppName}.conf"
openrgbCol="$HOME/.config/OpenRGB/colors.conf"

colors=($( cut -s -f 2 -d @ "${openrgbCol}" | cut -s -f 2 -d : ))

Adjust_Wallbash () {
  monetSatCmd="monet -c $(echo "${colors[@]}" | sed 's/ / -c /g') -s 1"
  saturated=($(eval "${monetSatCmd}"))

  oldSecondCol="${colors[3]}"
  newSecondCol="${saturated[3]}"
  
  distance1=$(monet -c "${saturated[0]}" -c "${saturated[3]}" -d)
  distance2=$(monet -c "${saturated[0]}" -c "${saturated[2]}" -d)

  if [[ "${distance2}" > "${distance1}" ]] ; then
    oldSecondCol="${colors[2]}"
    newSecondCol="${saturated[2]}"
  fi

  sed -i "s/${colors[0]}/${saturated[0]:1}/g" "${openrgbCol}"
  sed -i "s/${oldSecondCol}/${newSecondCol:1}/g" "${openrgbCol}"
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
    openrgbCmd+=" --startminimized --server"
  fi

  deviceList=("${devices[@]}")

  i=0
  while read -r line ; do
    if [[ $line =~ ^# ]] ; then
      read line1

      devName=$( echo $line | cut -s -f 2 -d : )
      devStr=$( IFS=$'\n'; echo "${deviceList[*]}" )
      mapfile -t devSearch < <( echo "${devStr}" | grep "${devName}" )
      
      device=${devSearch[0]}
      deviceList=( "${deviceList[@]/$device}" )

      devId=$( echo $device | cut -s -f 1 -d : )

      openrgbCmd+=" -d ${devId} -c ${line1} -m Direct"
    fi
    i=$((i+1));
  done < "$col"
  
  if [[ "${start}" == false ]] ; then
    openrgbCmd+=" -sp wallbash.orp"
  fi
  
  echo -e "${openrgbCmd}\n"
  eval "${openrgbCmd}"
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