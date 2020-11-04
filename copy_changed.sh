#!/bin/bash

set -e
set -o pipefail
cd `dirname $0`

for i in `find srv -type f -name \*.sls`
do
	src="$i"
	[ -f "/$src" ] || {
		echo "WARN: File '/$src' does not exist - IGNORED"
		continue;
	}

	[ -r "/$src" ] || {
		echo "WARN: File '/$src' unreadable - IGNORED"
		ls -l "/$src"
		continue;
	}

	#echo "'$src' -> '$i'"
	diff --color=always -u "$i" "/$src" || {
		echo -n "File $i changed - copy [y/N]?"
		read ans
		case "$ans" in
			y*|Y*)
				cp -v	"/$src" "$i" 
				;;
			*)
				echo "Copy Skipped"
				;;
		esac
	}
done
