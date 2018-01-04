#!/bin/bash
arch=$(uname -m) # only works for i386 or x86_64!

echo "[jaxx updater] .. checking for latest release"
cd $(dirname $0)

latestSource=$(curl -s -L "https://github.com/Jaxx-io/Jaxx/releases/latest" > latest.txt)
latestLink=$(grep "$arch"'.AppImage"' latest.txt | cut -d '"' -f 2)
rm latest.txt

latestLink=$(echo "https://github.com$latestLink")
latestVersion=$(basename $latestLink)

filePath=$(find . -name '*.AppImage' -print)
found=""

if [ -n "$filePath" ]; then found=$(basename $filePath); fi

echo "[jaxx updater] latest version=$latestVersion found=$found"

if [ "$latestVersion" != "$found" ]; then
	echo "[jaxx updater] updating to the latest version --> $latestVersion via cURL (please wait!)"
	curl -s -L $latestLink -O
	chmod +x $latestVersion

	if [ -n "$filePath" ]; then rm $found; fi

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
