#!/usr/bin/env sh


#// set variables

scrDir=$(dirname "$(realpath "$0")")
source $scrDir/globalcontrol.sh
roconf="${confDir}/rofi/clipboard.rasi"


rofi_pos

#// clipboard action

case "${1}" in
c|-c|--copy)
    cliphist list | rofi -dmenu -theme-str "entry { placeholder: \"Copy...\";}" -theme-str "${r_scale}" -theme-str "${r_override}" -theme-str "${fnt_override}" -config "${roconf}" | cliphist decode | wl-copy
    ;;
d|-d|--delete)
    cliphist list | rofi -dmenu -theme-str "entry { placeholder: \"Delete...\";}" -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roconf}" | cliphist delete
    ;;
w|-w|--wipe)
    if [ $(echo -e "Yes\nNo" | rofi -dmenu -theme-str "entry { placeholder: \"Clear Clipboard History?\";}" -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roconf}") == "Yes" ] ; then
        cliphist wipe
    fi
    ;;
*)
    echo -e "cliphist.sh [action]"
    echo "c -c --copy    :  cliphist list and copy selected"
    echo "d -d --delete  :  cliphist list and delete selected"
    echo "w -w --wipe    :  cliphist wipe database"
    exit 1
    ;;
esac

