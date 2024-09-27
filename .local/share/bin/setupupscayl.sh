#!/usr/bin/env sh

# Check if path is provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 <wallpaper_directory>"
  exit 1
fi

wallDir=$1
minWidth=2560
minHeight=1440

# Check if path is valid
if [[ ! -d "${wallDir}" ]] ; then
  echo "Invalid path provided !"
  exit 1
fi

for file in "${wallDir}"/* ; do
  if [[ -f "${file}" ]] ; then
    fwidth=$(identify -format "%w" "${file}")
    fheight=$(identify -format "%h" "${file}")
    upscFact=$((($minHeight + $fheight - 1) / $fheight))
    
    if [[ ! -d "${wallDir}/x${upscFact}" ]] ; then
      mkdir -p "${wallDir}/x${upscFact}"
    fi
    
    mv "${file}" "${wallDir}/x${upscFact}"
  fi
done