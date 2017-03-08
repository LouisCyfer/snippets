#!/bin/bash

askAlways=false
cancelHit=false
version="v0.2a"

askUser()
{
	runCmd=true

	if [ $askAlways = true ]; then
		response=""
		echo ""
		read -r -p "Ausführen von '$1'? (j/n ENTER-Taste=n)" response
		#response=${response,,}

		case $response in
		    j|J)
			runCmd=true;;
		    *)
			runCmd=false;;
		esac

	fi
	
	if [ $runCmd = true ]; then
		echo "" && echo "--> starte '$1'" && sleep 1s && $1
	else
		echo "" && echo "--> überspringe '$1'" && sleep 1s
	fi
}

RESULT=$(dialog --title "manUpdate.sh $version" --menu "Dieses script wird folgende ’apt-get’-Kommandos ausführen\nupdate, upgrade, dist-upgrade, autoremove, autoclean\n(in dieser Reihenfolge)\n\nBitte Wählen Sie eine Option:" 15 70 16 1 "genau so fortfahren" 2 "fortfahren, aber vor jedem Kommando fragen" 3 "abbrechen" 3>&1 1>&2 2>&3 3>&-);

clear

case $RESULT in
	1) echo "" && echo "überspringe keine der Kommandos." && echo ""  && sleep 2s;;
	2) askAlways=true;;
	*) echo "" && echo "breche Vorgang ab." && cancelHit=true;;
esac

if [ $cancelHit = false ];
then
	echo "" && echo "*Update/Upgrade*" && sleep 1s
	askUser "sudo apt-get update"
	askUser "sudo apt-get upgrade"
	askUser "sudo apt-get dist-upgrade"

	echo "" && echo "*Aufräumen*" && sleep 1s
	askUser "sudo apt-get autoremove"
	askUser "sudo apt-get autoclean"

	echo "" && echo "*Update Grub/initramfs*" && sleep 1s
	askUser "sudo update-grub"
	askUser "sudo update-initramfs -u"
fi

echo "" && echo "manUpdate.sh $version --> fertig. :)"
sleep 5s
exit 0
