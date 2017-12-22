#!/bin/bash

echo "[jaxx updater] .. checking for latest release"
cd $(dirname $0)

latestSource=$(curl -s -L "https://github.com/Jaxx-io/Jaxx/releases/latest" > latest.txt)
latestLink=$(grep 'AppImage"' latest.txt | cut -d '"' -f 2)
rm latest.txt
latestLink=$(echo "https://github.com$latestLink")
latestVersion=$(basename $latestLink)

filePath=$(find . -name '*.AppImage' -print)
found=$(basename $filePath)

echo "[jaxx updater] latest version=$latestVersion found=$found"

if [ $latestVersion != $found ]; then
	echo "[jaxx updater] updating to the latest version --> $latestVersion"
	curl -s -L $latestLink -O
	chmod +x $latestVersion

	rm $found

	if [ -f ~/.local/share/applications/appimagekit-jaxx.desktop ]; then
		echo " "
		echo "[jaxx updater] removing ~/.local/share/applications/appimagekit-jaxx.desktop"
		echo "[jaxx updater] you might need to re-apply if you wish to have a shared starter"
		rm ~/.local/share/applications/appimagekit-jaxx.desktop
	fi
fi

echo "[jaxx updater] executing $latestVersion"
sleep 1s

./$latestVersion
