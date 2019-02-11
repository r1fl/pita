#!/bin/sh

# assemble and run the bootloader

function assert() {
	if [[ $# != 0 ]]; then echo $1; fi
	echo "[?] usage: $0 <asmsrc> <timeout||-> [--debug]"
	exit 1
}
if [[ $# == 0 ]]; then assert; fi
timeout=$2

# assemble source file and test it

nasm -fbin $1 -o bootloader
ret=$?

if [[ $ret != 0 ]]; then assert; fi
if [[ `du ./bootloader | grep -Eoe "^[0-9]+"` == 0 ]]; then assert "[!] output is empty file"; fi

# qemu binary file ``bootloader``

if [[ $3 == "-d" || $3 == "--debug" ]]
then
	DEBUG=1
	#qemu-system-x86_64 --nographic -drive file=bootloader,format=raw -s &
	qemu-system-i386 --nographic -drive file=bootloader,format=raw -nic none -s &
else
	DEBUG=0
	qemu-system-x86_64 --nographic -drive file=bootloader,format=raw -nic none &
fi

# kill qemu
if [[ $timeout != '-' ]]; then sleep $timeout; fi
echo -e "\n"

while pgrep qemu-system-x86 &>/dev/null
do
	for p in `pgrep qemu-system-x86`; do kill -KILL $p; done
done


