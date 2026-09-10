#!/bin/sh
# Toggle the System Settings Dock badge (tile-data.dock-extra).
# Edit via defaults export/import so cfprefsd keeps the change; writing
# ~/Library/Preferences/com.apple.dock.plist directly is overwritten.

set -eu

DOMAIN=com.apple.dock
BUNDLE_ID=com.apple.systempreferences

TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT

/usr/bin/defaults export "$DOMAIN" "$TMP"

found=
i=0
while /usr/libexec/PlistBuddy -c "Print :persistent-apps:$i" "$TMP" >/dev/null 2>&1; do
  id=$(/usr/libexec/PlistBuddy -c "Print :persistent-apps:$i:tile-data:bundle-identifier" "$TMP" 2>/dev/null || true)
  if [ "$id" = "$BUNDLE_ID" ]; then
    found=$i
    break
  fi
  i=$((i + 1))
done

if [ -z "$found" ]; then
  printf '%s\n' "System Settings is not pinned in the Dock." >&2
  exit 1
fi

prev=$(/usr/libexec/PlistBuddy -c "Print :persistent-apps:$found:tile-data:dock-extra" "$TMP" 2>/dev/null || true)

if [ "$prev" = false ]; then
  next=true
else
  next=false
fi

/usr/bin/plutil -replace "persistent-apps.$found.tile-data.dock-extra" -bool "$next" "$TMP"
/usr/bin/defaults import "$DOMAIN" "$TMP"

/usr/bin/defaults export "$DOMAIN" "$TMP"
actual=$(/usr/libexec/PlistBuddy -c "Print :persistent-apps:$found:tile-data:dock-extra" "$TMP" 2>/dev/null || true)
if [ "$actual" != "$next" ]; then
  printf '%s\n' "Failed to persist dock-extra=$next in $DOMAIN." >&2
  exit 1
fi

/usr/bin/killall Dock

if [ "$next" = true ]; then
  printf '%s\n' "System Settings Dock badge enabled (dock-extra=true)."
else
  printf '%s\n' "System Settings Dock badge hidden (dock-extra=false)."
fi
