#!/bin/bash

askAlways=false
cancelHit=false
version="v0.2"

askUser ()
{
	runCmd=true

	if [ $askAlways = true ]; then
		response=""
		echo ""
		read -r -p "Ausführen von 'apt-get $1'? (j/n ENTER-Taste=n)" response
		#response=${response,,}

		case $response in
		    j|J) runCmd=true;;
		    *) runCmd=false;;
		esac

	fi
	
	if [ $runCmd = true ]; then
		echo "" && echo "--> starte apt-get $1" && sleep 1s && sudo apt-get $1
	else
		echo "" && echo "--> überspringe apt-get $1" && sleep 1s
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
	askUser "update"
	askUser "upgrade"
	askUser "dist-upgrade"

	echo "" && echo "*Aufräumen*" && sleep 1s
	askUser "autoremove"
	askUser "autoclean"
fi

echo "" && echo "manUpdate.sh $version --> fertig. :)"
sleep 5s
exit 0
