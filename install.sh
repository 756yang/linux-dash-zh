#!/bin/bash

IFS='' read -r -d '' checkcmd_install <<"EOT"
	function has_command () {
		local ans
		IFS='| ' read -a ans <<< "$*"
		for var in "${ans[@]}"; do
			command -v "$var" &>/dev/null && return
			ls "/usr/sbin/$var" &>/dev/null && return
		done
		return 1
	}
	while [ $# -gt 0 ]; do
		if ! has_command "$1"; then
			if { cat /proc/version | grep -E "MINGW|MSYS" &>/dev/null;}; then
				! ls /bin/pkgfile &>/dev/null && pacman -S pkgfile && pkgfile -u
				pkgname=$(pkgfile -r "^/(usr/local/bin|usr/bin|bin)/${1%%|*}.exe\$")
				[ -n "$pkgname" ] && pacman -S ${pkgname##*/}
			elif has_command apt-get; then
				! ls /bin/apt-file &>/dev/null && sudo apt install apt-file && sudo apt-file update
				pkgname=$(apt-file -x search "^/(usr/local/sbin|usr/local/bin|usr/sbin|usr/bin|sbin|bin)/${1%%|*}\$")
				[ -n "$pkgname" ] && sudo apt install ${pkgname%%:*}
			elif has_command pacman; then
				! ls /bin/pkgfile &>/dev/null && sudo pacman -S pkgfile && sudo pkgfile -u
				pkgname=$(pkgfile -r "^/(usr/local/sbin|usr/local/bin|usr/sbin|usr/bin|sbin|bin)/${1%%|*}\$")
				[ -n "$pkgname" ] && sudo pacman -S ${pkgname##*/}
			fi
			[ $? -ne 0 ] && {
				echo "$1 can not to execute!"
				exit 126
			}
		fi
		shift
	done
EOT
# all needed command as follows:
# git npm gawk grep egrep sed dig nc sensors lsb_release lastlog crontab hostname uname
# ifconfig arp netstat ping ps cat which tr w sort uniq dirname basename readlink head wc whereis lscpu df date
# only do necessary checks:
bash -c "$checkcmd_install" @ git npm gawk grep sed dig ncat crontab sensors lsb_release lastlog
[ $? -ne 0 ] && exit 1

git clone --depth 1 https://github.com/NoBey/linux-dash-zh.git
cd linux-dash-zh/server
npm install --production

echo "please run the command to start linux-dash-zh:"
echo "sudo LINUX_DASH_SERVER_PORT=8080 node linux-dash-zh/server/index.js"
