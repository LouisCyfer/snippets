#!/bin/bash

percentFree=25 # set the limit percent (sorta heatpoint)
ask=true # set to false if you want it straight cleared (in conky you might need to enter your root passwd)

getFreeRatio()
{
    totalRAM=$(awk -F"[: ]+" '/MemTotal/ {print $2;exit}' /proc/meminfo)
    freeRAM=$(awk -F"[: ]+" '/MemFree/ {print $2;exit}' /proc/meminfo)
    freeRatio=$(($freeRAM*100/$totalRAM))
    echo "$freeRatio"
    return 0
}

checkAgain()
{
    # replace with any of your most fav. outut terminal >.<
    gnome-terminal --title="running 'sudo sysctl -w vm.drop_caches=3' ..." --geometry=100x20+55+35 -e "sudo sysctl -w vm.drop_caches=3"

    if [ $(getFreeRatio) -lt "$percentFree" ]; then
	echo "STILL less than $percentFree% free, consider actions NOW!"
    fi
}

output=$(getFreeRatio)"% (cleanup at $percentFree%|ask:$ask)"

echo $output

optionID=0
option1=""
option2=""

if [ $(getFreeRatio) -lt "$percentFree" ]; then
    echo "your RAM is less than $percentFree% free"

    if [ $ask = true ]; then
	response=$(zenity --question --text "Do you wish to free your RAM with 'sudo sysctl -w vm.drop_caches=3'?"; echo $?)

	case "$response" in
	0 ) checkAgain ;;
	* ) echo "no action taken" ;;
	esac
	
    else
	echo "--> question skipped"
	checkAgain
    fi
fi
exit 0
