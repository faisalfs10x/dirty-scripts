#!/bin/bash

# Cisco+AnyConnect
OPENCONNECT_PID=""
RUNNING=""
 
function checkOpenconnect {
    ps -p $OPENCONNECT_PID &> /dev/null
    RUNNING=$?
 
    #echo $RUNNING &>> reconnect.log
}
 
function startOpenConnect {
    # start here open connect with your params and grab its pid
    echo "Password@123" | sudo openconnect --servercert sha256:c01fb20cffcdb3d1a1abcbc9b26604598606d4aff1150b7a14a96XXXXXXXXXXX -u admin --authgroup=CORP-STAFF-AD --passwd-on-stdin access.corp.com & OPENCONNECT_PID=$!
}
 
startOpenConnect
 
while true
do
    # sleep a bit of time
    sleep 10
    checkOpenconnect
    [ $RUNNING -ne 0 ] && startOpenConnect
done


#https://confluence.jaytaala.com/display/TKB/Continuous+connection+to+Cisco+AnyConnect+VPN+with+linux+Openconnect#ContinuousconnectiontoCiscoAnyConnectVPNwithlinuxOpenconnect-Creatingascripttoreconnectwhendisconnected

# Let's at least lock this file down to be only readable by root:
# sudo chown root:root vpn.sh
# sudo chmod 711 vpn.sh

# Running script in background
# Once your happy with your script you can run said script as a background script:
# cd ~/
# sudo ./vpn.sh &

# Stopping background script
# To stop/disconnect the VPN and script, use ps to find the PID's of the VPN script and the openconnect process by:
# sudo ps -aux | grep vpn
# sudo kill 10525 28445
