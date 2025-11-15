#! /usr/bin/bash

print_usage() {
	echo "usage: make-lib.sh -t <target>"
	echo ""
	echo "targets:"
	echo "  x86_64-pc-windows-gnu"
}

valid_targets="
x86_64-pc-windows-gnu"

is_valid_target() {
	echo $valid_targets | grep -F -q -x $1
}

if [ $# -eq 0 ]; then
	print_usage
	exit 1
fi

cd "$(dirname "${BASH_SOURCE[o]}")"

while getopts ':t:' flag; do
	case "${flag}" in
		t) if is_valid_target "${OPTARG}"; then
			echo "building for ${OPTARG}"
			echo "cargo build --release --target ${OPTARG}"
			cargo build --release --target ${OPTARG}
			if [ ! -d ./releases ]; then mkdir releases; fi
			cd releases
			if [ ! -d ./${OPTARG} ]; then mkdir ${OPTARG}; fi
			cd ${OPTARG}
			cp ../../tuile-crossterm.h .
			cp ../../target/${OPTARG}/release/libtuile_crossterm.a .
			# tar -czf ./libtuile_crossterm-${OPTARG}.tar.gz *.h *.a *.d
			# rm *.h *.a *.d
			cd ..
		else
			print_usage
			exit 1
		fi ;;
		*)  print_usage
			exit 1 ;;
	esac
done