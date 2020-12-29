#!/bin/bash 
# faisal May 2,2020
# https://github.com/faisalfs10x
# usage: 1. change the desire subnet value at line 13
# 		 2. change the desire ports to be scanned in the array at line 27
# requirement nc [v1.10-41.1+b1]

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

file="/tmp/live_host.txt"

liveHost(){
subnet=192.168.0.

for ip in {1..254} ;
do
	(ping -c 1 $subnet$ip | grep "bytes from" | cut -d " " -f 4 | tee >> $file & )
done
}

echo -e "     \e[93mhello $USER@$HOSTNAME:- ";
echo -e "  \e[92mLive Host Port Scanner";
echo -e "  \e[92mHttps://github.com/faisalfs10x";
date +"%A, %b %d, %Y %I:%M %p"
echo -e "\e[0m"

portScan(){
port=(21 22 23 25 80 135 445 9000)

if [[ -f "$file" ]]; then
	while IFS=': ' read -r liveIP;
	do
		echo -e "\e[92mIP: $liveIP\e[0m"
		nc=$(nc -nvz -w 1 $liveIP "${port[@]}" 2>&1 | cut -d " " -f 3,4,5)
		if [[ $nc ]]; then
			out=$(printf '%s\n' "$nc")
			printf '%s\n' "$out"
			printf '%s\n' ""
		else
			echo "no open port"
			echo ""	
		fi
	done <"$file"		
else
echo "file $file not exist"	
fi
}

liveHost
portScan
rm $file
printf "uptime: "$SECONDS"(s) | PID: "$$" "
printf '%s\n' ""
