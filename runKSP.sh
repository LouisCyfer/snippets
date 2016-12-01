#!/bin/bash

#NOTE: please change the folders to your advantage!
Kpaths[0]="/mnt/.../Kerbal Space Program_1.1.2" # folder 1 (for me its the backup of KSP v1.1.2)
Kpaths[1]="/mnt/.../Kerbal Space Program_1.1.3" # folder 2 (same as above but KSP v1.1.3)
Kpaths[2]="/mnt/.../Kerbal Space Program_current" # folder 3
Kpaths[3]="/mnt/.../Kerbal Space Program_test" # folder 3

KSPpath=""

KSPapp="KSP.x86_64" # erase the '_64' if your want to run the 32bit version of KSP
kspParams="-force-opengl" #"-force-opengl" "-force-opengl -force-gfx-direct"

goAhead=true
optionID=0
kspPID=0

clear
echo "[:: KSP Launcher ::]"
echo ""
echo "--> Wich folder you wish to use?"

optionID=0

options[0]="run from ${Kpaths[0]}"
options[1]="run from ${Kpaths[1]}"
options[2]="run from ${Kpaths[2]}"
options[3]="run from ${Kpaths[3]}"

response=$( zenity --title="Question" --width=600 --height=250 --list --radiolist --text="" \
--column="" --column="pick one of the following options" \
FALSE "${options[0]}" FALSE "${options[1]}" TRUE "${options[2]}" FALSE "${options[3]}" )

case "$response" in
${options[0]} )	
    optionID=1 ;;
${options[1]} )		
    optionID=2 ;;
${options[2]} )		
    optionID=3 ;;
${options[3]} )		
    optionID=4 ;;	    
esac

if [ $optionID = 0 ]; then
    goAhead=false

else
    case "$response" in
    ${options[0]} )
	KSPpath=${Kpaths[0]} ;;
    ${options[1]} )
	KSPpath=${Kpaths[1]} ;;
    ${options[2]} )
	KSPpath=${Kpaths[2]} ;;
    ${options[3]} )
	KSPpath=${Kpaths[3]} ;;	    
    esac

    echo "using path '$KSPpath'"
    echo ""
    echo "--> Wich application you wish to run?"

    optionID=0
    options[0]="run KSP"
    options[1]="run ckan.exe per mono"

    response=$( zenity --title="Question" --width=600 --height=250 --list --radiolist --text="" \
    --column="" --column="pick one of the following options" TRUE "${options[0]}" FALSE "${options[1]}" )

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
	# cd "$KSPpath" && ./$KSPapp &
	
	echo 'exporting LD_PRELOAD="libpthread.so.0 libGL.so.1"'
	export LD_PRELOAD="libpthread.so.0 libGL.so.1"

	echo 'exporting __GL_THREADED_OPTIMIZATIONS=1'
	export __GL_THREADED_OPTIMIZATIONS=1
	
	echo "running with params $kspParams"
	./$KSPapp $kspParams &

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
	echo "[:: starting ckan.exe (Mono) ::]"
	cd "$KSPpath" && mono "ckan.exe" && cd ;;
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
