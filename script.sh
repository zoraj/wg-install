#!/bin/bash

set -e

# Usage check
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <CLIENT_IP> <SERVER_PUBLIC_KEY> <SERVER_ENDPOINT>"
    exit 1
fi

CLIENT_IP=$1
SERVER_PUBLIC_KEY=$2
SERVER_ENDPOINT=$3

WG_DIR="/etc/wireguard"
PRIVATE_KEY_FILE="$WG_DIR/private.key"
PUBLIC_KEY_FILE="$WG_DIR/public.key"
WG_CONF="$WG_DIR/wg0.conf"

# Detect OS and install WireGuard
echo "[+] Detecting OS and installing WireGuard..."

if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        ubuntu|debian)
            sudo apt update -y
            sudo apt install -y wireguard
            ;;
        fedora)
            sudo dnf install -y wireguard-tools
            ;;
        *)
            echo "Unsupported OS: $ID"
            exit 1
            ;;
    esac
else
    echo "Cannot detect OS. /etc/os-release not found."
    exit 1
fi

echo "[+] Generating WireGuard keys..."
sudo mkdir -p $WG_DIR
sudo chmod 700 $WG_DIR

sudo wg genkey | sudo tee $PRIVATE_KEY_FILE | wg pubkey | sudo tee $PUBLIC_KEY_FILE > /dev/null
sudo chmod 600 $PRIVATE_KEY_FILE $PUBLIC_KEY_FILE

CLIENT_PRIVATE_KEY=$(sudo cat $PRIVATE_KEY_FILE)

echo "[+] Writing wg0.conf..."
sudo tee $WG_CONF > /dev/null <<EOF
[Interface]
Address = $CLIENT_IP
PrivateKey = $CLIENT_PRIVATE_KEY

[Peer]
PublicKey = $SERVER_PUBLIC_KEY
Endpoint = $SERVER_ENDPOINT
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF

sudo chmod 600 $WG_CONF
sudo wg-quick up wg0
echo "[+] WireGuard client configuration completed."
sudo wg show wg0
