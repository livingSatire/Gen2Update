#!/bin/bash

set -euo pipefail # We must be very strict about this script. 

echo "Gen2Update by livingSatire!"

# Check if root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Use Doas or Sudo. (Doas is preferable)" >&2
   exit 1
fi

fastfetch || true # We would rather the script not crash due to fastfetch not working

echo "Syncing Gentoo Repos"
emaint -a sync

echo "Updating Gentoo"
emerge --ask --verbose --update --deep --newuse --with-bdeps=y --backtrack=30 @world

echo "Updating Flatpak"
flatpak update --system -y 

echo "Cleaning Up Flatpak"
flatpak uninstall --unused
flatpak repair

echo "Cleaning up Gentoo with Portage"
emerge --ask --depclean
emerge @preserved-rebuild

echo "Done updating"
fastfetch || true # Shows the update is done
sleep 20
cmatrix -bsr # Screen Saver, due to user being away from computer
