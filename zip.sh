#!/bin/bash

g='\033[0;32m'
r='\033[0;31m'
nc='\033[0m'

clear
echo -e "
    ___________ _____  _  _______ _      _               
   |___  /_   _|  __ \| |/ /_   _| |    | |        /\    
      / /  | | | |__) | ' /  | | | |    | |       /  \   
     / /   | | |  ___/|  <   | | | |    | |      / /\ \  
    / /__ _| |_| |    | . \ _| |_| |____| |____ / ____ \ 
   /_____|_____|_|    |_|\_\_____|______|______/_/    \_\ 
                   coded by ${r}sombrebongos${nc}
"
read -p "File Name: " zipfile
read -p "Wordlist (default: w.txt): " wordlist

if [[ -z "$zipfile" || -z "$wordlist" ]]; then
    echo "[x] input cannot be empty!"
    exit 1
fi

if [[ ! -f "$zipfile" ]]; then
    echo "[x] file not found: $zipfile"
    exit 1
fi

if [[ ! -f "$wordlist" ]]; then
    echo "[x] wordlist not found: $wordlist"
    exit 1
fi

spinner() {
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    while true; do
        i=$(( (i+1) % ${#spin} ))
        printf "\r[~] start bruteforce ${spin:$i:1}"
        sleep 0.1
    done
}

spinner &
SPINNER_PID=$!

found=0
while read pass; do
    unzip -P "$pass" -t "$zipfile" > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        found=1
        break
    fi
    sleep 0.3
done < "$wordlist"

kill $SPINNER_PID >/dev/null 2>&1
wait $SPINNER_PID 2>/dev/null

echo ""
if [[ $found -eq 1 ]]; then
    echo -e "${g}[✓] Password Found: $pass"
else
    echo "${r}[x] Password Not Found :(${nc}"
fi
