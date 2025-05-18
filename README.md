# WireGuard Client Auto Installer

This repository contains a simple Bash script to automate the installation and configuration of a **WireGuard client** on a Debian-based system.

## ✅ What It Does

- Installs WireGuard using `apt`
- Generates client private and public keys
- Creates `/etc/wireguard/wg0.conf` with the specified client IP, server public key, and endpoint
- Prepares the client to connect securely to your WireGuard server

---

## 🔧 Requirements

- A Debian-based system (e.g., Ubuntu)
- `curl` installed
- Root/sudo privileges

---

## 🚀 Installation & Setup

### 1. Prepare Your Values

Before running the script, you should have:

- `CLIENT_IP`: VPN IP address for the client (e.g., `10.0.0.2`)
- `SERVER_PUBLIC_KEY`: The public key of your WireGuard server
- `SERVER_ENDPOINT`: The server's endpoint address and port (e.g., `vpn.example.com:51820`)

### 2. Run the Script

```bash
curl -sSfL https://raw.githubusercontent.com/zoraj/wg-install/master/script.sh | bash -s -- <CLIENT_IP> <SERVER_PUBLIC_KEY> <SERVER_ENDPOINT>
