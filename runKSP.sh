#!/bin/bash

KSPpath=""
prePath="/mnt/...." #change this to your preference (i have several sub-folders, so the pre-folder is the same)

#if you add/remove, you have to edit the zenity-response variable below
Kpaths[0]="Kerbal Space Program_current"
Kpaths[1]="Kerbal Space Program_test"
Kpaths[2]="Kerbal Space Program_1.1.2"
Kpaths[3]="Kerbal Space Program_1.1.3"
Kpaths[4]="Kerbal Space Program_1.2.1"

maxPathes=${#Kpaths[@]}

KSPapp="KSP.x86"
found64bit=false

if [ "$(uname -m)" = "x86_64" ]; then
    KSPapp=$KSPapp"_64"
    found64bit=true
fi

#possible params --> -force-opengl -force-opengl -force-gfx-direct
kspParams=" -force-opengl"
# kspParams=""

preRun="" # preRun="taskset -c 2-3 " --> forcing to set other cpu cores (for me it was not quite performance improving)

goAhead=true
optionID=0
kspPID=0

clear

info=""

msg="32bit"
if [ "$found64bit" = true ]; then
    msg="64bit"
fi

info="NOTE: found $msg OS $(uname -s), using '$KSPapp$kspParams' if you choose to start KSP"

echo "$info"

optionID=0
options[0]=""
optionsStr=""

idx=0
# ${#Kpaths[@]}

while [ $idx -lt $maxPathes ]; do
    options[$idx]="$prePath${Kpaths[$idx]}"

    if [ $idx = $(($maxPathes -1)) ]; then
	optionsStr="$optionsStr${options[$idx]}"
    else
	optionsStr="$optionsStr${options[$idx]}|"
    fi

    let idx=idx+1
    # idx=$(($idx + 1))
done

echo ""
echo "[:: KSP Launcher | pick path ::]"
echo ""
echo "--> Wich folder you wish to use?"

response=$(zenity --title="[:: KSP Launcher | pick path ::]" --width=600 --height=250 --list --radiolist --text="$info" \
--column="" --column="Wich folder you wish to use?" \
TRUE "${options[0]}" FALSE "${options[1]}" FALSE "${options[2]}" FALSE "${options[3]}" FALSE "${options[4]}")

case "$response" in
${options[0]} )	
    optionID=1 ;;
${options[1]} )		
    optionID=2 ;;
${options[2]} )		
    optionID=3 ;;
${options[3]} )		
    optionID=4 ;;	    
${options[4]} )		
    optionID=5 ;;	    
esac

if [ $optionID = 0 ]; then
    goAhead=false

else
    pickID=$(($optionID - 1))
    KSPpath=$response
    # KSPpath=$prePath${Kpaths[$(($optionID - 1))]}

    echo "using path '$KSPpath'"
    echo ""
    echo "--> Wich application you wish to run?"

    optionID=0
    options[0]="run '$KSPapp$kspParams'"
    options[1]="run mono 'ckan.exe'"

    response=$( zenity --title="[:: KSP Launcher | run application ::]" --width=600 --height=250 --list --radiolist --text="$info" \
    --column="" --column="Wich application you wish to run?" TRUE "${options[0]}" FALSE "${options[1]}" )

    case "$response" in
    ${options[0]} )		
	optionID=1 ;;
    ${options[1]} )		
	optionID=2 ;;	    
    esac
fi

if [ $optionID = 0 ]; then
    goAhead=false

else
    case $optionID in
    1 )
	echo ""
	echo "[:: starting KSP ::]"
	echo ""
	
	cd "$KSPpath"
	
	echo 'running --> export LC_ALL=C'
	export LC_ALL=C

	echo 'running --> export LD_PRELOAD="libpthread.so.0 libGL.so.1"'
	export LD_PRELOAD="libpthread.so.0 libGL.so.1"

	echo 'running --> export __GL_THREADED_OPTIMIZATIONS=1'
	export __GL_THREADED_OPTIMIZATIONS=1

	echo "executing > $preRun./$KSPapp$kspParams &"
	sleep 2s
	$preRun./$KSPapp$kspParams &

	echo ""
	sleep 1s

	kspPID=$(pidof "$KSPapp")
	echo "$kspPID"

	if [ -n "$kspPID" ]; then
	    echo "starting logger:"
	    echo "----------------"
	    tail -f "$KSPpath/KSP.log" &
	
	    while :
	    do
		kspPID=$(pidof "$KSPapp")
		
		if [ -n "$kspPID" ]; then
		    sleep 1s
		else
		    echo "$KSPapp has closed"
		    break
		fi
	    done
	fi

	cd ;;
    2 )
	echo ""
	echo "[:: starting ckan.exe (Mono) ::]"
	cd "$KSPpath" && mono 'ckan.exe' && cd ;;
    esac
fi

if [ $goAhead = false ]; then
    echo "You've cancelled starting-up."
    zenity --info --text="You've cancelled starting-up."
fi

echo ""
echo "done. :)"
sleep 5s

exit 0
