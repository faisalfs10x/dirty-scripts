#!/bin/bash
# Download all the vpn config at https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip
# https://github.com/faisalfs10x

echo -e "     \e[93mhello $USER@$HOSTNAME:- ";
echo -e "  	    \e[92mNordvpn";
echo -e "  \e[92mhttps://github.com/faisalfs10x";
date +"  %A, %b %d, %Y %I:%M %p"
echo -e "\e[0m"

usage()
{
cat << EOF
usage: bash nordvpn.sh -c my
-c    | --country_name      (Required)            Randomly pick specific country
-a    | --random_all        (master)              Randomly pick country
-l    | --list_country				  List available country
-h    | --help                                    Menu
EOF
}


country_name=
random_all=master # default value

file=$PWD/ovpn_tcp
cntry=$2

randomize_all(){

pickrandom=$(ls -1 $file | shuf -n 1)
echo 
echo -e "\e[93mconnecting to: $pickrandom";
echo -e "\e[0m"
cd $file && openvpn $pickrandom

}

random_country(){

cn=$(ls -1 $file | grep $cntry | shuf -n 1) 
echo 
echo -e "\e[93mrandomly connecting to specific: $cn";
echo -e "\e[0m"
cd $file && openvpn $cn

}

view_country(){

list=$(ls $file | cut -c 1-2 | sort -u) 
echo 
echo $list
echo

}

which openvpn &> /dev/null
if [ $? != 0 ]; then
    echo \"openvpn\" takde dlm PATH
    exit 2
fi

while [ "$1" != "" ]; do
    case $1 in
        -c | --country_name )
            shift
            country_name=$1
        ;;
        -a | --random_all  )
            shift
            random_all=$1   
        ;;    
        -l | --list_country  )
            shift
            list_country=$1   
        ;;            
        -h | --help )    usage
            exit
        ;;
        * )              usage
            exit 3
    esac
    shift
done

# randomize_all
if [[ -z $random_all ]]; then
    echo "Ok Random all" 
    randomize_all
    exit


elif [[ -n $country_name ]]; then
    echo "Randomly pick specific country" 
    random_country 
    exit

elif [[ $list_country == $list_country ]]; then
    echo "List of Available Country" 
    view_country 
    exit

fi

#random_country
