#!/bin/bash
 
 #This is a script created for raspberry Pi + monitor. turning the screen off when 2 users are away "from wifi"
 # and turn on the screen when 1 or 2 users are back on wifi. 

 # make sure you have hping3 installed for this script
 #Enter your ip of your device here
while true
do
DEVICES1="192.168.1.170"
DEVICES2="192.168.1.171"
dates=$( date +"%T" )
display=$( vcgencmd display_power )
user1(){
for i in `echo $DEVICES1`; do
    # Change dev and eth0 if needed
    ip neigh flush dev eth0 $i
    hping3 -2 -c 10 -p 5353 -i u1 $i -q >/dev/null 2>&1
    sleep 1
    # Only arp specific device, grep for a mac-address
    status=`arp -an $i | awk '{print $4}' | grep "..:..:..:..:..:.."`
    statusMessage="OFF"
    #A mac will be 17 characters including the ":"
    if [ ${#status} -eq 17 ]; then
        echo "$dates Phone1 $i is detected!" #| sudo tee -a /var/log/screen.log
        statusMessage="ON"
        if [ "$display" = "display_power=0" ]
        then
        echo "$dates screen is off for $DEVICES1 , but user is home. turning on screen" #| sudo tee -a /var/log/screen.log
        vcgencmd display_power 1 2
        fi
    else
        echo "Phone $i is not present" #| sudo tee -a /var/log/screen.log
        statusMessage="OFF"
        echo "$dates Phone1 $DEVICES1 is not home. checking for $DEVICES2 .." #| sudo tee -a /var/log/screen.log
        user2
    fi
done
sleep 10
exit
}
user2(){
for i in `echo $DEVICES2`; do
    # Change dev and eth0 if needed
    ip neigh flush dev eth0 $i
    hping3 -2 -c 10 -p 5353 -i u1 $i -q >/dev/null 2>&1
    sleep 1
    # Only arp specific device, grep for a mac-address
    status1=`arp -an $i | awk '{print $4}' | grep "..:..:..:..:..:.."`
    statusMessage="OFF"
    #A mac will be 17 characters including the ":"
    if [ ${#status1} -eq 17 ]; then
        echo "$dates Phone2 $i is detected!" #| sudo tee -a /var/log/screen.log
        statusMessage="ON"
        if [ "$display" = "display_power=0" ]
        then
        echo "$dates screen is off for $DEVICES2 , but user is home. turning on screen" #| sudo tee -a /var/log/screen.log
        vcgencmd display_power 1 2
        fi
    else
        echo "Phone $i is not present" #| sudo tee -a /var/log/screen.log
        statusMessage="OFF"
        if [ "$display" = "display_power=0" ]
        then
        echo "$dates Screen is already off" #| sudo tee -a /var/log/screen.log
        else
        vcgencmd display_power 0 2
        fi
    fi
done
sleep 60
exit
}
user1
done
