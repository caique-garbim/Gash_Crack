#!/bin/bash

# Constantes para facilitar a utilização das cores
GREEN='\033[32;1m'
BLUE='\033[34;1m'
RED='\033[31;1m'
RED_BLINK='\033[31;5;1m'
END='\033[m'

# Função chamada quando cancelar o programa com [Ctrl]+[c]
trap __Ctrl_c__ INT

__Ctrl_c__() {
   # __Clear__
    printf "\n${RED_BLINK} [!] Aborted task!${END}\n\n"
    exit 1
}

# Entrada de argumentos
if [ "$1" == "" ] || [ "$2" == "" ]
then
	echo " "
        echo -e "${RED}        ╻   ┏━╸┏━┓┏━┓╻ ╻   ┏━╸┏━┓┏━┓┏━╸╻┏    ╻  ${END}"
        echo -e "${RED}       ┏┛   ┃╺┓┣━┫┗━┓┣━┫   ┃  ┣┳┛┣━┫┃  ┣┻┓   ┗┓ ${END}"
        echo -e "${RED}       ╹    ┗━┛╹ ╹┗━┛╹ ╹╺━╸┗━╸╹┗╸╹ ╹┗━╸╹ ╹    ╹ ${END}"
        echo -e "${RED}               MD5 | SHA-256 | SHA-512          ${END}"
	echo " "
	echo -e "${BLUE} [*] Specify wordlist and complete hash as argument:${END}"
	echo -e "${GREEN}     Exemple: $0 wordlist.txt complete_hash${END}"
	echo " "
	echo -e "${RED} [!] You must type a '\' before the '$' of the hash. ${END}"
	echo -e "${BLUE}     This way: ${RED}\\\$${BLUE}6${RED}\\\$${BLUE}s4lt123${RED}\\\$${BLUE}q5pC.....${END}"
	echo " "
else
	# Separando a hash
	echo $2 > temp_file1
	HASHTYPE=$(cat temp_file1 | cut -d "$" -f2)
	MYSALT=$(cat temp_file1 | cut -d "$" -f3)
	MYHASH=$(cat temp_file1)
	rm -rf temp_file1 2>/dev/null
	
	# Descobrir tipo da hash
	if [ "$HASHTYPE" == "1" ]
	then
		HASHPRINT="MD5"
	elif [ "$HASHTYPE" == "5" ]
	then
		HASHPRINT="SHA-256"
	elif [ "$HASHTYPE" == "6" ]
	then
		HASHPRINT="SHA-512"
	# Caso nao encontrar o tipo da hash
	else
		echo " "
		echo -e "${RED_BLINK}  [!] Undefined hash type${END}"
		exit
	fi
	
	# Gerar a hash
	echo " "
	echo -e "${RED}        ╻   ┏━╸┏━┓┏━┓╻ ╻   ┏━╸┏━┓┏━┓┏━╸╻┏    ╻  ${END}"
        echo -e "${RED}       ┏┛   ┃╺┓┣━┫┗━┓┣━┫   ┃  ┣┳┛┣━┫┃  ┣┻┓   ┗┓ ${END}"
        echo -e "${RED}       ╹    ┗━┛╹ ╹┗━┛╹ ╹╺━╸┗━╸╹┗╸╹ ╹┗━╸╹ ╹    ╹ ${END}"
        echo -e "${RED}               MD5 | SHA-256 | SHA-512          ${END}"
	echo " "
	echo -e "${BLUE} [*] Generating hashes ${GREEN}$HASHPRINT${END} ${BLUE}with the salt${END} ${GREEN}$MYSALT${END}"
	echo " "
	echo -e "${BLUE} [*] Comparing the hashes...${END}"
	echo " "

	# Laço de repeticao para gerar/comparar as hashes
	for senha in $(cat $1);
	do
		# Imprime a senha que ira testar no arquivo
		echo " [+] Password: $senha" > temp_file;
		# Imprime a hash gerada no arquivo
		openssl passwd -$HASHTYPE -salt $MYSALT $senha >> temp_file;

		# Compara a hash
		valida=$(tail -n 1 temp_file);
		if [ "$valida" == "$MYHASH" ]
		then
			cat temp_file
			# Remove temp files
			rm -rf temp_file*
			exit
		fi
	done
	
	# Remove temp files
	rm -rf temp_file*
	
	# Laço de repeticao terminou e nao foi encontrada a hash
	echo -e "${RED_BLINK}  [!] Not found${END}"
	exit
fi
