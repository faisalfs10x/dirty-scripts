#!/bin/bash

# OpenVPN status log path
STATUS_LOG="/var/log/openvpn/status.log"
# Webhook URL from Discord
DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/<>"
# File to keep track of connected clients
CLIENTS_FILE="/tmp/openvpn_clients.log"

# send message to Discord
send_discord_message() {
    local message="$1"
    if [ -z "$message" ]; then
        echo "No message to send to Discord."
        return
    fi
    curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$message\"}" $DISCORD_WEBHOOK_URL
}

# extract current clients and virtual addresses
get_client_info() {
    awk -F',' '
        /OpenVPN CLIENT LIST/ {flag=1; next}
        /ROUTING TABLE/ {flag=0}
        flag && NR>2 {
            client[$1] = $2
        }
        /ROUTING TABLE/ {flag=1}
        flag && NR>2 {
            if ($2 in client) {
                print $1 "," $2
            }
        }
    ' $STATUS_LOG | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'  # trim spaces
}

# Load previously seen clients
if [ -f "$CLIENTS_FILE" ]; then
    mapfile -t previous_clients < "$CLIENTS_FILE"
else
    previous_clients=()
fi

# Extract current client info
current_clients=($(get_client_info))

# Debug output for current clients
echo "Current clients: ${current_clients[@]}"

# Compare with previous clients
for client_info in "${current_clients[@]}"; do
    if [[ ! " ${previous_clients[@]} " =~ " ${client_info} " ]]; then
        # New client detected
        IFS=',' read -r virtual_address common_name <<< "$client_info"
        message="New OpenVPN client connected:\nCommon Name: $common_name\nVirtual Address: $virtual_address at $(date "+%Y-%m-%d %H:%M:%S")"
        echo "Sending message: $message"  # Debug output for message
        send_discord_message "$message"
    fi
done

# Update the file with current clients
printf "%s\n" "${current_clients[@]}" > "$CLIENTS_FILE"
