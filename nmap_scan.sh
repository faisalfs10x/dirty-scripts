#!/bin/bash

# Check if filename is provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

filename="$1"

# Check if the provided file exists
if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' not found."
    exit 1
fi

# Read the file, extract unique IP addresses, and consolidate ports for each IP
declare -A ports  # Associative array to store IP addresses and their ports

while IFS=: read -r ip port; do
    # Append port to existing array or create a new one
    ports["$ip"]="${ports["$ip"]} $port"
done < "$filename"

# Perform nmap scan for each unique IP with its respective ports
for ip in "${!ports[@]}"; do
    # Remove leading whitespace if any
    ports_list="${ports[$ip]}"
    ports_list="${ports_list#"${ports_list%%[![:space:]]*}"}"

    # Perform the nmap scan
    echo "[+] NMAP SCAN START FOR $ip [+]"
    echo ""
    nmap -Pn -n -sS -A -T4 -vv --min-rate 1000 -p "$(echo "$ports_list" | tr ' ' ',' )" "$ip" -oA nmap_scan_telco_$ip
    echo "[+] NMAP SCAN END [+]"
    echo ""
done
