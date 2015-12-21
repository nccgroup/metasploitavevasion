Metasploit AV Evasion
=======================

Metasploit payload generator that avoids most Anti-Virus products.

Released as open source by NCC Group Plc - http://www.nccgroup.com/

Developed by Daniel Compton, daniel dot compton at nccgroup dot com

https://github.com/nccgroup/metasploitavevasion

Released under AGPL see LICENSE for more information

===================================
Updated 08/2015 by Jason Soto, jason_soto [AT] jsitech [DOT] com

Removed Deprecated Commands in favor of MsfVenom

Updated 12/2015 
Removed use of ifconfig for more Distro Compatibility, Using "ip route" for ip Detection
Added gcc compiler use condition for use in Arch Based Distros
Using "msfconsole -x" for auto Listener launching instead of resource file
Code Cleanup

www.jsitech.com

https://github.com/jsitech

Twitter = @JsiTech

Tested on Kali Linux



Installing    
=======================

    git clone https://github.com/nccgroup/metasploitavevasion.git

chmod +x the avoid.sh file before use.


How To Use
=======================
    ./avoid.sh

Then follow the on screen prompts.

Features
=======================

* Easily generate a Metasploit executable payload to bypass Anti-Virus detection
* Local or remote listener generation
* Disguises the executable file with a PDF icon
* Executable opens minimised on the victims computer
* Automatically creates AutoRun files for CDROM exploitation


Screen Shot    
=======================

<img src="http://commonexploits.com/tools/avoid/avoidscreenshot.png" alt="Screenshot" style="max-width:100%;">
Change Log
=======================

Version 1.5 - Official release.
