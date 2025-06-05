#!/usr/bin/env bash
# Exit immediately if a command exits with a non-zero status
set -e

cat << 'EOF'
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@%*%@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@%*++#@%%%%@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@#++++**#@@%%%##%@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@#++++++**##@@@%%%%###%@@@@@@@@@@@@@@
@@@@@@@@@@%*+++++++****##%%%%%%#######%%@@@@@@@@@@
@@@@@@@@@@#*-:......................:::+@@@@@@@@@@
@@@@@@@@@@####*=::..............:::::-+%@@@@@@@@@@
@@@@@@@@@@#######*+::........:::::::-+%%@@@@@@@@@@
@@@@@@@@@@###########+::::::::::::::*%%%@@@@@@@@@@
@@@@@@@@@@############%#+:::::::::-#%%%%@@@@@@@@@@
@@@@@@@@@@####%%#######**-:::::::-#%%%%%@@@@@@@@@@
@@@@@@@@@@####%%###******-::::::-#@@%%%%@@@@@@@@@@
@@@@@@@@@@######*********-:::---+*#%@@%%@@@@@@@@@@
@@@@@@@@@@##**********+++------==++++*%%@@@@@@@@@@
@@@@@@@@@@#+=++++++++++++-----==------=*@@@@@@@@@@
@@@@@@@@@@@@@%+=====++++=----------=#@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@+=======-------=%@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@%*====----+%@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@#+-*%@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@   ____                          @@@@@@@@@
@@@@@@@@  / ___|   _ _ __ ___  ___  _ __ @@@@@@@@@
@@@@@@@@ | |  | | | | '__/ __|/ _ \| '__|@@@@@@@@@
@@@@@@@@ | |__| |_| | |  \__ \ (_) | |   @@@@@@@@@
@@@@@@@@  \____\__,_|_|  |___/\___/|_|   @@@@@@@@@
@@@@@@@@                                 @@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
EOF

printf "%s\n" "$ascii_art"

echo -e "=> No need to be frustrated anymore, cursor-installer is here to help! \n"

echo -e "Beginning installation process. Press Ctrl+C to cancel at any time.\n"

if command -v apt >/dev/null; then
	sudo apt-get update >/dev/null
	sudo apt-get install -y git >/dev/null
else
  echo -e "/n❌ Unsupported distro (need apt). Exiting."; exit 1
fi

echo "Cloning cursor-installer..."
rm -rf ~/.local/share/cursor-installer
mkdir -p ~/.local/share/cursor-installer
git clone https://github.com/gouveags/cursor-installer.git ~/.local/share/cursor-installer >/dev/null
if [[ $BRANCH_REF != "main" ]]; then
	cd ~/.local/share/cursor-installer
	git fetch origin "${BRANCH_REF:-stable}" && git checkout "${BRANCH_REF:-stable}"
	cd -
fi

echo -e "\n🚀 Starting cursor-installer installation...\n"
source ~/.local/share/cursor-installer/install.sh