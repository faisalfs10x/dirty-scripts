#!/bin/bash
# https://github.com/faisalfs10x
# 07-JAN-2020

echo
echo "DNS Amplification Attack test via openresolver"
echo "Grep list of DNS IP from target ASN thru shodan-cli and test via openresolver"
echo "Require Shodan-CLI : pip install -U --user shodan" #https://help.shodan.io/command-line-interface/0-installation
echo "Example Usage: ./dnsAmp.sh AS15169" #AS15169 is Google ASN
echo

target_ASN=$1

DNS_IP=$(shodan search asn:$1 port:53 | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
for ip in $DNS_IP;
do
    TEST=$(dig +short +tries=1 +time=2 test.openresolver.com TXT @$ip | grep open-resolver-detected)
    if [ -z "$TEST" ]; then

        echo "$ip is good"
    else
    	echo -e "\e[93m$ip is vulnerable\e[0m";
    	#echo -e "\e[0m"
    fi
done
