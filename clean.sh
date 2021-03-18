red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`


( rm ./tests/asm/* ; rm ./tests/bin/* ) 2> /dev/null
if [ $? -eq 0 ]; then
    echo "${green}Files Deleted ${reset}"
else
    echo "${red}Empty directory${reset}"
fi