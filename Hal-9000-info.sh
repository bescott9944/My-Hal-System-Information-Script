#!/bin/bash
#
#####################################################################
# <<<---================}[ Hal-9000-info.sh ]{================--->>>
# Current Version: v.1.3.0 Modified by Bruce Scott 09/2/2020
# Script Name  : Hal-9000-info.sh v.1.3.0
# Description  : Displays System and IP Network information
# Dependencies : awk, ip, nmcli, wget, dmidecode, awk, grep, hdpram, lsblk, inxi, network-tools
# Arguments    : None
# Author       : Bruce E. Scott, 03 Jun 2019
# Email        : 
# Linux Form   : I can be reached at https://www.ezeelinux.com/talk/index.php (bescott9944)
# Comment 1.   : v.0.3 script concept and building.. Current Version: v.1.3.0 Modified by Bruce Scott 09/2/2020
# Comment 2.   : Requires root/sudo privileges
# Note         : dmidecode may produce error messages in some systems. They can be
#                safely ignored and removed from file with any text editor.
#
#####################################################################
#
#       <---> "ABOUT MyStat.sh" <--->     Copyright (C) 2019, Bruce E. Scott
#   <<<---================}[ Name Chang on 09/02/2020 ]{================--->>>
#       <<<---================}[ Hal-9000-info.sh ]{================--->>>
#
#####################################################################
#
# This script was created using other scripts and commands that I added
# to get to more system Information. This script should be in the ~/bin...
# mystat.sh - This file - Copyright (C) 2019, by Bruce E. Scott
#
###########################################
#
# A BIG Thanks goes out to Richard Romig for his 2 scripts.
#               # Mystat.sh is based on these fantastic scripts...
# sysinfo.sh    # The 2 scripts were written and
# ipinfo.sh     # Copyright (C) in 2018 by Richard Romig
#		        # Email: rick.romig@gmail.com
#----------------------------------------
# A BIG Thanks goes out to Leon.P for his Hdd Function for the script.
# The function list all the hard drives and there information for the output
# for the script.... Thank You very Much!! Leon.P
# He can be reached at https://www.ezeelinux.com/talk/index.php
# Web: https://leon-plickat.org/
#
###########################################
#
# I pulled all the commands from the 2 above "Snippet Scripts" which do most of the work 
# and I add my own to make up this full script. This script displays the information on screen
# and a file in your /home/your-name under the name of the system "XXXXX.stat"...
# I merged all the scripts and commands to make it all work...
# I also wrote some of the code my self and modified a lot of it for better output... :D --Bruce E. Scott
#
############################################
#
#            <<====> ( GNU General Public License )<====>>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program. If not, see <https://www.gnu.org/licenses/>.
####################################################################
#
# v.0.3 Beta Change log. 04/12/2019
# Script concept and start building and Planing.. -Bruce
#----------------------------------------
# v.0.3 Beta Change log. 05/10/19
# <--( inxi -c0 -Fxzd )-->
# I added the "inxi -c0 -Fxzd" command to get another set information that has the Mobo -Bruce
# NOTE: This decision led to some issues later in the Change log -Bruce
#----------------------------------------
# I pulled all the commands from the 2 above "Snippet Scripts" which do most of the work 
# and I add my own to make up this full script. This script displays the information on screen
# and a file in your /home/your-name under the name of the system "XXXXX.stat"...
# I merged all the scripts and commands to make it all work... :D --Bruce E. Scott
#----------------------------------------
# v.0.4 Beta Change log. 05/22/2019
# After a bunch of changes and testing we moved the Version to v.1.0 -Bruce
#----------------------------------------
# v.1.0 change log 6/03/29
# Today I moved the script from Beta to a working version of v.1.0 -Bruce
#----------------------------------------
# v.1.0 Change log. 6/14/19
# Added new commands for the IP. Inxi, and document updates. Fixed bugs in the command
# structure. Various other small changes and fixes....
# 6/14/19 added the path to "inxi" so that it would not rely on the $PATH
# to function...
#----------------------------------------
# NOTE::: 6/14/19  <----"TO DO"----> ???
# You need to changed the ("nmcli dev" an "print $1" to $6) variables so it will would read
# "Active" Nic cards in a 2 Nic card system..... Like this...
#
#  ethint=$(nmcli dev | grep 'ethernet' | awk '{print $1}') 
#  ethint=$(nmcli con show --active | grep 'ethernet' | awk '{print $6}')
#  ethint=$(nmcli dev | grep 'ethernet' | awk '{print $1,$3}' to get -->($1)enp2s0  ($3)connected
#-----------------------------------------------------------------------------------
#   wifint=$(nmcli dev | grep 'wifi' | awk '{print $6}')
#   wifint=$(nmcli dev | grep 'wifi' | awk '{print $1}') ##  Changed the $1 to $6... -Bruce
#----------------------------------------
# v1.0.2 change log. 6/16/19
# Hard drive function section added today!
# A BIG Thanks goes out to Leon.P for his Hdd Function for the script.
# The function list all the hard drives and there information for the output
# for the script.... Thank You very Much!! Leon.P
# The inxi section is still flaky... -Bruce
#----------------------------------------
# v1.0.3 Change log. 6/17/19
# Added more Computer Information variables and commands so that 
# the board info is pilled with dmidecode command. Created new output
# variables for the information so that is can be displayed on the screen.
# I added the same for the Bios/vendor too..
# --> Note:  On some Distro's "hdpram" is not installed by default.
# You will have to install it for this section to function... 
# still dealing with inxi not always working on various Distro's --Bruce E. Scott
#----------------------------------------
# v1.0.3 Change log. 7/04/19
# Made several changes today. I moved all the variables to the top o the script
# for similarity.
# I have found that for some reason this script will not run in a folder that is
# in the $PATH statement on MX & Manjaro Arch Distro's. Works fine on other Debian/Ubuntu Distro's...
# Someday I will figure it out. I is a issue with "INXI". In the script and in the $PATH, the 
# script gets stuck in a loop on the "INXI" command in the script and will run until the
# system crashes..... One has to use the key combo "Ctrl + C" to exit the script... -Bruce
#----------------------------------------
# v1.0.3 Update log 8/11/19
# Manjaro and MX Linux sometimes has issues running the inxi
# command at times. Sometimes it works and sometime it hangs on inxi
# and starts to eat CPU time and Memory until the system will crash!
# You will have to watch and see if the screen hangs for along time
# at a blank screen with a flashing cursor! Amy more that 5 seconds
# you will have to hit the " CTRL + C " to stop the script!
# I have not figured it out yet... -Bruce
#----------------------------------------
# v1.0.3 Change log. 8/18/19
# Finely give up a week ago and made a ~/home/bin/info to store
# the main Mystat-system_name file and place a mystat like mystatMX or mystatDF for Defiant
# this is the only thing I know to do as INXI is still hanging on every Distro but Mint 18.3...
# I did this on all the box's till I get the $PATH issue sorted out, So far
# the EzeeTalk forum has been stumped too! --Bruce
#----------------------------------------
# v1.0.3 Change Log. 8/18/19 - 8/19/19
# Deck_luck on EzeeTalk.com offered some of his time to help fix the INXI hanging in a loop.
# He's trying to figure out the issue!
# I sent Deck_luck the master script and all the information on all the Distro's
# with there Version numbers for INXI. Also sent all the .bashrc's from all of the Distro's...
# Thanks Deck_luck! -Bruce
#----------------------------------------
# v1.0.3 Change Log. 8/20/19
# On 8/20/19 Deck_luck on EzeeTalk.com came up with this small script that fix's
# the INXI command from hanging and getting caught in a loop on any INXI v2.3.x.x-00
# or higher! There is a bug in the newer versions that keep calling the parent --version.
# Deck_luck sent a bug report tot he Dev and the Dev said that it was a "child corner bug"
# and closed the bug report even after Deck_luck sent his the process, scripts, the fix and the
# Dev is a bit of a but...
# Thank you Deck_luck for your time and the fix! -Bruce
#----------------------------------------
# v1.0.3 Change log. 8/25/19
# After several days of testing the Mystat script with Deck_luck's fix for the INXI
# hanging issues and further testing on all the Distro's I have on Hardware, also on some
# VM's I can say that is is fixed and works as intended... The script has been tested on
# Mint 18.3 - 19.2, Manjaro, Linux-MX, Peppermint 10 as well sever Disto's in VM's.... -Bruce
#----------------------------------------
# v1.0.3 Change log. 8/26/19
# I have decided to raise the Version Number to v1.2.0....
# I do not see any issues at this time..... -Bruce
#----------------------------------------
# v1.2.1 Change Log 09/17/2019
# I Split the AWK command into 2 AWK commands to get a
# better "Gateway and Adapter" information for the Network...
#
# I Added the "AWK Output" to the Network Section to change the IP Router Information..
#
# I also added NEW "Other HDD Information:" to get more and better HDD information...
# I also Added VENDOR, UUID information to the"lsblk" to the Hard drive Section...
# I also added the "df -h" to the Hard drive Information Section for more information...
###
# I also made a bunch of Line and Display output Changes so that
# the STDOUT look better. Version Number updated too...v.1.2.2   -Bruce
#----------------------------------------
# v.1.2.2 Change Log 09/19/19
# Battery Interfaces
#----------------------------------------
# I fixed The Battery Display option when script is Ran on a Laptop
# so that the information is correct. Was never checked on my Laptop
# until today.
# Also added the ( echo -e "Battery Information:") to the output, it did not have one
# Things to do; write the code to show when the "AC" power is plugged in and it is charging... 09/19/2019/ -Bruce
#----------------------------------------
# Changed the AWK output to read the "IP4.GATEWAY to get a better IP output
# because some Distro's do not use the IP$.DNS, like Ubuntu Server 18.04. I checked Mint 18.3,
# X 18.3, Manjaro, Peppermint 10. So this should be good for now... 09/20/2019 -Bruce
#----------------------------------------
# v.1.2.2 Change Log 09/20/19
# I went through all the code and found that there was 2 of the same "variables" that were in separate areas
# along with others from the "Coping and Pasting" of all the scripts together. Most were not causing any issues
# but the 2 variables were making some issues on Ubuntu Server.
# So I moved all the script variables to the top of the script to the "Base variables" section so that
# they are all together and streamlines the Code... -Bruce
#----------------------------------------
# v.1.2.2 Change Log 09/20/19
# I am now checking and testing the script on Mint 18.3 / 19.2, MX-18.3, Manjaro 18.04,
# Ubuntu Server 18.04 Distro's. This is done to check "Portability" of the script.....
# Also worked on some working and added some fancy ASCII art stuff to make the output pretty!
# Started testing on laptops to see IF the wifi and battery section reports correctly as I never
# checked these functions....                                                                       -Bruce
#----------------------------------------
# v.1.2.2 Change Log 10/01/19
# Checking code. Fixed some spacing on some lines. Added some more separators...
# **--- TO-DO Still need to work on the Wifi issues not showing like I want. Battary/AC reporting..  -Bruce
#----------------------------------------
# v.1.2.2 Change Log 10/09/19
# Today I did some more punctuation fixing. Also I worked on the Wifi section for laptops
# to show correct ports for wifi and either net... Started testing on my Dell Latitude 6410
# and my Acer Extensa 4420 to get the IP,Port,Battery reporting to work correctly on the laptops.
# Checked Port reporting with and without the Ethernet cable plugged in and Wifi turned off. So Far so Good!
#
# *** TO-DO Item, see if there is a way to show when the laptop is on the battery or AC when script is ran...***
# Tomorrow start testing on the Desktops again and make sure that the script function correctly on Desktops!   -Bruce
#----------------------------------------
# v.1.2.2 Change log 09/02/2020
# Well the time has come for a Name change to Hal-9000-Info and a version change...
# This will also be published on my GitHub and GitLab accounts @ bescott9944/Hal-9000-Info...
# The script has worked just fine the last few months so I am going to call it done for now! :-)
# The new Version Number is v.1.3.0 Modified 09/2/2020 -Bruce
#----------------------------------------
#
#
####################################################################

# Set BASH to quit script and exit on errors:

 set -e
#
  echo
  echo -e  "\t\t<---====+++++++++++++++++++++++++++++++++++====--->"
  echo -e "\t<<<---================}[ Hal-9000 OS v.2010 ]{================--->>>"
  echo -e  "\t\t<---====+++++++++++++++++++++++++++++++++++====--->\n"
  echo -e "\t~:>  Hello, I'm The HAL-9000 Computer.                <Beep:Beep:Beep>\n"
  echo -e "\t~:>  I will be Processing Your Information today..    <Beep:Beep:Beep>"
  echo -e "\t~:>  Please Hold this will take a Bit..  Thank You!   <Beep:Beep:Beep>"
  echo -e "\t~:>  We May Need You Password $USER..                 <Beep:Beep:Beep>\n"
  echo -e "\t~:>  I am Checking.......                             <Beep:Beep:Beep>"
  echo -e "\t~:>  ..---___---****---___...                         <Beep:Beep:Beep>"
  echo -e "\t~:>  Yes we need your password.. Please Enter It Now!......."
  echo -e  "\t\t<---====+++++++++++++++++++++++++++++++++++====--->"
#
# Base variables
#
myuser=$USER
myhost=$HOSTNAME
infofile="/home/$myuser/$myhost.stat"
today=$(date +"%d %B %Y %H:%M:%S")
#
# Computer information

biov=$(sudo /usr/sbin/dmidecode -s bios-vendor 2>/dev/null)
biodate=$(sudo /usr/sbin/dmidecode -s bios-release-date 2>/dev/null)
mfgname=$(sudo /usr/sbin/dmidecode -s system-manufacturer 2>/dev/null)
prodname=$(sudo /usr/sbin/dmidecode -s system-product-name 2>/dev/null)
vername=$(sudo /usr/sbin/dmidecode -s system-version 2>/dev/null)
sernum=$(sudo /usr/sbin/dmidecode -s system-serial-number 2>/dev/null)
bmfgname=$(sudo /usr/sbin/dmidecode -s baseboard-manufacturer 2>/dev/null)
bprodname=$(sudo /usr/sbin/dmidecode -s baseboard-product-name 2>/dev/null)
bvername=$(sudo /usr/sbin/dmidecode -s baseboard-version 2>/dev/null)
bsernum=$(sudo /usr/sbin/dmidecode -s baseboard-serial-number 2>/dev/null)

# RAM and CPU

physmem=$(grep MemTotal /proc/meminfo | awk '{print $2}' | xargs -I {} \
echo "scale=4; {}/1024^2" | bc)
cpuinfo=$(grep 'model name' /proc/cpuinfo | uniq | cut -c 14-)

# Network

ethint=$(nmcli dev | awk '/ethernet/ {print $1}')
wifint=$(nmcli dev | awk '/wifi/ {print $1}')

#    **** ethint=$(nmcli dev | awk '/ethernet/ {print $1}')
#    **** wifint=$(nmcli dev | awk '/wifi/ {print $1}')

#############
#
# 6/14/19 "TO DO"
# You need to changed the ("nmcli dev" an "print $1" to $6) varables so it will would read
# "Active" Nic cards in a 2 Nic card system..... Like this...
#
# ethint=$(nmcli dev | grep 'ethernet' | awk '{print $1}') 
# ethint=$(nmcli con show --active | grep 'ethernet' | awk '{print $6}')
# ethint=$(nmcli dev | grep 'ethernet' | awk '{print $1,$3}' to get -->($1)enp2s0  ($3)connected
#-----------------------------------------------------------------------------------
#   wifint=$(nmcli dev | grep 'wifi' | awk '{print $6}')
#   wifint=$(nmcli dev | grep 'wifi' | awk '{print $1}') ##  Changed the $1 to $6...
#
############
ethernet=$(/usr/bin/lspci | grep 'Ethernet controller' | cut -c 30-)
wireless=$(/usr/bin/lspci | grep 'Network controller' | cut -c 29-)

# IP addresses

publicip=$(wget -qO- http://ipv4.icanhazip.com)
localip1=$(ip -o -f inet addr show | awk -v name="$ethint" '$0~name {print $4}')
localip2=$(ip -o -f inet addr show | awk -v name="$wifint" '$0~name {print $4}')


# Write data to file in user's home directory

clear
{
  echo -e
  echo -e  "\t    <---====+++++++++++++++++++++++++++++++++++====--->
\t <<<---================}[ Hal-9000-info.sh ]{================--->>>
\t Mystat.sh, v.0.3 created on 04/12/2019 Copyright 2019, Bruce E. Scott
\t SysInfo, Copyright 2019, Richard Romig....
\t Current Version: v.1.3.0 Modified by Bruce Scott 09/2/2020" > "$infofile"
#
  echo -e  "\t    <---====+++++++++++++++++++++++++++++++++++====--->"
  echo -e "============"
  echo -e "File created:"
  echo -e "============"
  echo -e "$today\n"
#
  echo -e  "\t    <---====+++++++++++++++++++++++++++++++++++====--->"
  echo -e "\t           System information for $myhost:"
  echo -e  "\t    <---====+++++++++++++++++++++++++++++++++++====--->"
#
  echo -e "\n============"
  echo "Bios Information:"
  echo -e "============"
  echo -e "\tBios Manufacturer: $biov"
  echo -e "\tBios Release Date: $biodate"
#
  echo -e "\n============"
  echo "System Information:"
  echo -e "============"
  echo -e "\tSystem Manufacturer: $mfgname"
  echo -e "\tSystem Product Name: $prodname"
  echo -e "\tSystem Version: $vername"
  echo -e "\tSystem Serial Number: $sernum"
#
  echo -e "\n============"
  echo "Board Information:"
  echo -e "============"
  echo -e "\tBoard Manufacturer: $bmfgname"
  echo -e "\tBoard Product Name: $bprodname"
  echo -e "\tBoard Version: $bvername"
  echo -e "\tBoard Serial Number: $bsernum"
#
  echo -e "\n============"
  echo "Distro Information:"
  echo -e "============"
#  echo -e "\tDistro OS: $(/usr/bin/lsb_release -d | cut -c 14-)"  # Changed to "OS" to "Disto OS" to get info in the $infofile. 6/14/19 -bruce.
#  echo -e "\tCodename: $(/usr/bin/lsb_release -c | cut -c 11-)"   # Added to get Codename 6/14/19 -bruce.
#  echo -e "\tRelease: $(/usr/bin/lsb_release -r | cut -c 10-)"  # Added to get Release 6/14/19 -bruce.

  echo -e "\tDistro OS: $(/usr/bin/lsb_release -d | cut -c 14-)"  # Changed to "OS" to "Disto OS" to get info in the $infofile. 6/14/19 -bruce.
  echo -e "\tDesktop: $(inxi -S 2>/dev/null | grep 'Desktop' | awk '{print $4 " " $5}')" # Added to get Desktop Info 10/19/16 -Bruce
  echo -e "\tCodename: $(/usr/bin/lsb_release -c | cut -c 11-)"   # Added to get Codename 6/14/19 -bruce.
  echo -e "\tRelease: $(/usr/bin/lsb_release -r | cut -c 10-)"  # Added to get Release 6/14/19 -bruce.
  echo -e "\tKernel Ver: $(cat /proc/sys/kernel/osrelease 2>/dev/null grep '.' | awk '{print}')" # Added to get Kernel Ver Info 6/19/19 -Bruce
#  echo -e "\tKernel Bit: $(inxi -S 2>/dev/null | grep 'Kernel' | awk '{print$6" "$7" "$8$9}')"
  echo -e "\tKernel Bit: $(inxi -S 2>/dev/null | grep 'Kernel' | awk '{print$7" "$8$9}')" # Added to get Kernel Bit Ver Info 10/19/19 -Bruce
#
  echo -e "\n============" 
  echo "CPU Information:"
  echo -e "============"
  echo -e "\t$cpuinfo"
#
  echo -e "\n============"
  echo "RAM Information:"
  echo -e "============"
  echo -e "\t$physmem GB"
# 
 echo -e "\n============"
  echo "Graphics Adapter: "
  echo -e "============"
  echo -e "\t$(/usr/bin/lspci | grep 'VGA' | cut -c 36-)"
#
# Network Interfaces Section
#
  echo -e "\n============"
  echo "Network Adapters:"
  echo -e "============"
 if [ -n "$ethernet" ]; then
   echo -e "\tEthernet:"
	echo -e "\tPort Name: $ethint"
	echo -e "\tNic Card: $ethernet"
#   echo -e "\tEthernet: $ethint = $ethernet"
#    read -r ethadd < "/sys/class/net/enp3s10/address"
    read -r ethadd < "/sys/class/net/$ethint/address"
    echo -e "\tMAC Address: $ethadd"
 fi
if [ -n "$ethint" ] && [ -n "$localip1" ]; then
  echo -e "\tEthernet Address: $localip1"
elif [ -n "$ethint" ]; then
  echo -e "\tEthernet Cable: Not connected\n"
fi
#
# Wirless Wifi Section
#
  if [ -n "$wireless" ]; then
    echo -e "\n============"
    echo -e "Wireless Information:"
    echo -e "============"
    echo -e "\tWireless:"
    echo -e "\tPort Name: $wifint"
    echo -e "\tNic Card: $wireless"
    read -r wifiadd < "/sys/class/net/$wifint/address"
    echo -e "\tMAC Address: $wifiadd"
  fi
if [ -n "$wifint" ] && [ -n "$localip2" ]; then
  echo -e "\tWireless Ethernet: $localip2"
elif [ -n "$wifint" ]; then
  echo -e "\tWireless Ethernet: Not connected\n"
fi
#
####
#    Added the "IP Route" to get Nic card Information...
#
  echo -e "\n============"
  echo -e "IP Route Inforomation:" # Added this to get more Nic Information. 6/14/19 -bruce.
  echo -e "============"
#	/usr/bin/ip route
#   /sbin/ip route
  /sbin/ip route | awk '/default/ "\t"{print}'  #--=== #### NOTE: I Added the "AWK Output" to change
                                                       #### the IP Router Information on 09/17/2019  -Bruce
#  If your "IP" is not in the /sbin/ip. Then uncomment the above
#  "/usr/bin/ip route" line. Then add a line "#" comment to the /sbin/ip/route
#  Solus 4.0, Mint 18.3 keeps their "IP" in the "/sbin"... -Bruce
#
#
# Display IP Information
  echo -e "\n=============="
  echo -e "IP Information:"
  echo "=============="
  echo -e "\tPublic IP:"
  echo -e "\t$publicip\n"
#
  echo -e "\tLocal IP:"
if [ -n "$ethint" ] && [ -n "$localip1" ]; then
  echo -e "\tEthernet:
     $localip1\n"
elif [ -n "$ethint" ]; then
  echo -e "\tEthernet: Not connected\n"
fi
#
if [ -n "$wifint" ] && [ -n "$localip2" ]; then
  echo -e "\tWireless: $localip2"
elif [ -n "$wifint" ]; then
  echo -e "\tWireless: Not connected\n"
fi
  echo -e "\tDefault Gateway:"
 /sbin/ip route | awk '/default/ {print "\t"$3}'
  echo -e "\n\tEthernet Adaptor ID:"                   ### NOTE: Split the AWK command into 2 AWK commands to get
 /sbin/ip route | awk '/default/ {print "\t"$5}'       ### better Gatway and Adaptor information on 09/17/2019  -Bruce
# /sbin/ip route | awk '/scope/ {print "\t"$9}'
#   If you have a error here, change this "/sbin/ip" to "/bin/ip"
#   for your system if needed. To find out in a terminal,type: "whereis ip on CLi" -bruce
  echo
  echo -e "\tDNS Servers:"
# /usr/bin/nmcli dev show | awk '/IP4.DNS/ {printf "\t%s\n",$2}'
#         ## Changed the AWK output to read the "IP4.GATEWAY to get a better IP output
#         ## because some Distro's do not use the IP$.DNS, like Ubuntu Server 18.04. I checked Mint 18.3,
#         ## MX 18.3, Manjaro, Peppermint 10. So this should be good for now... 09/20/2019 -bruce
/usr/bin/nmcli dev show | awk '/IP4.GATEWAY/ {printf "\t%s\n",$2}'
#
# Hard drive
#    Note: On some Distro's "hdpram" is not installed by default.
#    You will have to install it for this section to function... -Bruce E. Scott -6/18/19
  echo -e "============"
#  fi
echo -e "Hard Disk Information:"
  echo -e "============"
   for Disk in /dev/sd[a-z]
do

    hdmodel=$(sudo /sbin/hdparm -I "${Disk}" | grep 'Model Number' | cut -c 22-)
    hdserial=$(sudo /sbin/hdparm -I "${Disk}" | grep 'Serial Number' | cut -c 22-)
    hdsize=$(sudo /sbin/hdparm -I "${Disk}" | grep 'GB' | cut -c 38-)
    trans=$(sudo /sbin/hdparm -I "${Disk}" | grep 'Transport:' | cut -c 22-)
    firm=$(sudo /sbin/hdparm -I "${Disk}" | grep 'Firmware Revision' | cut -c 22-)

    echo -e "\tModel Number : $hdmodel"
    echo -e "\tSerial Number: $hdserial"
    echo -e "\tCapacity: $hdsize"
    echo -e "\tTransport: $trans"
    echo -e "\tFirmware Revision: $firm\n"

done
### Note: Added "Other HDD Information:" to get more HDD information on 09/17/2019  -Bruce
  echo -e "\n============"
  echo -e "Other HDD Information:"
  echo -e "============"
    df -h     >> "$infofile"
####
  echo -e "\n============"
  echo -e "Partition Information:"
  echo -e "============"
    /bin/lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,VENDOR,UUID  #### NOTE: Added VENDOR, UUID information to the"lsblk" on 09/17/2019  -Bruce
##
# Battery Interfaces
#-----
# I fixed The Battery Display option when script is Ran on a Laptop
# so that the information is correct. Was never checked on my Laptop
# until today.
# Also added the ( echo -e "Battery Information:") to the output, it did not have one
# Things to do; write the code to show when the "AC" power is plugged in and it is charging... 09/19/2019/ -Bruce
#-----
#
  if  
    [ "$(ls -A /sys/class/power_supply/)" ]; then
  echo -e "\n============"
  echo -e "Battery Information:"
  echo -e "============"
#    echo -e "Charging Power:"
    echo -e "\nPower and battery:"
    ls -1 /sys/class/power_supply
  fi
####
#
 echo -e "\n============"
 echo -e "Inxi - System Data Information:"
 echo "================"
#
#   On 8/20/19 Deck_luck on EzeeTalk.com came up with this small script that fix's
#   the INXI command from hanging and getting caught in a loop on any INXI v2.3.x.x-00
#   or higher! There is a bug in newer versions that keep calling the parent --version.
#   Thank you Deck_luck for your time and the fix! -Bruce
#
if [[ "${1}" == "--version" ]] ; then
	# patch for inxi_3.0.32 parent --version anomaly Per Deck_luck 8/20/19
	exit 1
fi
#
# Looking for INXI 06/06/2020
# /usr/bin/inxi -c0 -Fxzd
#if [ /bin/inxi ] ; then
inxi -c0 -Fxzd

#elif [ /usr/bin/inxi ] ; then
#/usr/bin/inxi -c0 -Fxzd

#elif [ /usr/local/bin/inxi ] ; then
#/usr/local/bin/inxi -c0 -Fxzd

#else
#echo -e "INXI Not Found!"
#/bin/inxi -c0 -Fxzd
 
#fi 
#
  echo -e "\n"
  echo -e  "\t\t\t<---====+++++++++++++++++++++++++++++++++++====--->"
  echo -e "\t\t  <<<---================ Hal-9000 OS v.2010 ================--->>>\n"
  echo -e " \t~:>  The data is being retrieved "$USER"!!" "One Moment... \t\t\t<Beep:Beep:Beep>"
  echo -e " \t~:>  I Found The Data You Requested... \t\t\t\t\t<Beep:Beep:Beep>\n"
  echo -e " \t~:>  Here Is The Data For "$HOSTNAME"'s"" OS System You Wanted....."
  echo -e " \t     Thank You For Using Your Hal-9000 Computer...\t\t\t<Beep:Beep:Beep>\n"
  echo -e " \t~<:> Goodbye $USER! \t\t\t\t\t\t\t<Beep:Beep:Beep>"
  echo -e  "\t\t\t<---====+++++++++++++++++++++++++++++++++++====--->"
 echo -e "\t\t\t    <<<---==============================--->>>"
} >> "$infofile"
#
cat "$infofile"
exit
