red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

if [ $# -ne 1 ]; then
	echo "${red}Require 1 arg${reset}"
	exit
fi
cd tests/bin
( ./$1 ) 2> /dev/null
if [ $? -ne 0 ]; then
    echo "${red}Executable File Not Found${reset}"
fi