red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

if [ $# -ne 1 ]; then
	echo "${red}Require 1 arg${reset}"
	exit
fi
EXE=$(basename -s .asm $1)
if nasm -gdwarf -f elf32 $1; then
	exec=`echo $1 | cut -d'.' -f 1`
	exec="${exec}.o"
	if gcc -m32 $exec -o ${EXE}; then
		echo "${green}Compiled${reset}"
		mv $1 ./tests/asm/
		mv ${EXE} ./tests/bin/
		rm ${exec}
	else
		echo "${red}Error to Compile with C"
	fi
else
	echo "${red}Error to Compile with Nasm${reset}"
fi
