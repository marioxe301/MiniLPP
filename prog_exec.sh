red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

if [ $# -ne 2 ]; then
	echo "${red}Require 2 args${reset}"
	exit
fi

echo "${green}Generating Asembly Code${reset}"
( ./build/minilpp $1 > $2 ) 2> /dev/null
if [ $? -eq 0 ]; then
    echo "${green}Generated ${reset} $2 ${green}File${reset}"
else
    echo "${red}Fail to generate Code${reset}"
fi