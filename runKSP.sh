#!/bin/bash

KSPpath1="/mnt/.../Kerbal Space Program_1.1.2" # folder 1 (for me its the backup of KSP v1.1.2)
KSPpath2="/mnt/.../Kerbal Space Program_1.1.3" # folder 2 (same as above but KSP v1.1.3)
KSPpath=""

KSPapp="KSP.x86_64" # erase the '_64' if your want to run the 32bit version of KSP

goAhead=true
optionID=0
kspPID=0

clear

echo "[:: KSP Launcher ::]"
echo ""
echo "--> Wich folder you wish to use?"

optionID=0
option1="run from $KSPpath1"
option2="run from $KSPpath2"
option3=""

response=$( zenity --title="Question" --width=550 --height=250 --list --radiolist --text="" \
--column="" --column="pick one of the following options" FALSE "$option1" TRUE "$option2" )

case "$response" in
$option1 )		
    optionID=1 ;;
$option2 )		
    optionID=2 ;;	    
esac

if [ $optionID = 0 ]; then
    goAhead=false

else
    case "$response" in
    $option1 )
	KSPpath=$KSPpath1 ;;
    $option2 )		
	KSPpath=$KSPpath2 ;;	    
    esac

    echo "using path '$KSPpath'"
    echo ""
    echo "--> Wich application you wish to run?"

    optionID=0
    option1="run KSP"
    option2="run ckan.exe per mono"

    response=$( zenity --title="Question" --width=550 --height=250 --list --radiolist --text="" \
    --column="" --column="pick one of the following options" TRUE "$option1" FALSE "$option2" )

    case "$response" in
    $option1 )		
	optionID=1 ;;
    $option2 )		
	optionID=2 ;;	    
    esac
fi

if [ $optionID = 0 ]; then
    goAhead=false

else
    case $optionID in
    1 )
	echo "[:: starting KSP ::]"
	echo ""

	cd "$KSPpath" && ./$KSPapp &
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

    sleep 1s

    echo ""
    echo "--> Do you wish to free your RAM now by one of the following commands?"

    optionID=0
    option1="run 'sudo sysctl -w vm.drop_caches=3'"
    option2="run 'sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches'"
    option3="don't free RAM"

    response=$( zenity --title="Question" --width=550 --height=250 --list --radiolist --text="" \
    --column="" --column="pick one of the following options" FALSE "$option1" FALSE "$option2" TRUE "$option3" )

    case "$response" in
    $option1 )
	optionID=1
	echo "running 'sudo sysctl -w vm.drop_caches=3' ..."
	sudo sysctl -w vm.drop_caches=3 ;;
    $option2 )
	optionID=2
	echo "running 'sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches' ..."
	sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches ;;
    $option3 )
	optionID=3
	echo "no action taken" ;;
    esac

    if [ $optionID = 0 ]; then
	echo "no action taken"
    fi
    sleep 5s
fi

if [ $goAhead = false ]; then
    echo "You've cancelled starting-up."
    zenity --info --text="You've cancelled starting-up."
fi

echo ""
echo "done. :)"
sleep 5s

exit 0
