#!/bin/sh
PLIST=~/Library/Preferences/com.apple.dock.plist

for i in $(seq 0 99); do
	if id=$(/usr/libexec/PlistBuddy "$PLIST" -c "Print :persistent-apps:$i:tile-data:bundle-identifier" 2> /dev/null); then
		if [ "$id" = 'com.apple.systempreferences' ]; then
			break
		fi
	else
		echo 'System Preferences not in Dock'
		exit 1
	fi
done

prev=$(/usr/libexec/PlistBuddy "$PLIST" -c "Print :persistent-apps:$i:tile-data:dock-extra")

if [ "$prev" = false ]; then
	toggle=true
else
	toggle=false
fi

/usr/libexec/PlistBuddy "$PLIST" -c "Set :persistent-apps:$i:tile-data:dock-extra $toggle"

killall Dock
