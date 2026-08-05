#!/bin/bash
set -e

KEY_PATH="$HOME/.ssh/github_deploy_key"
SERVER_USER="deployuser"
SERVER_IP="192.168.233.136"

echo "=== 1. Testing SSH connectivity ==="
ssh -i "$KEY_PATH" -o ConnectTimeout=5 -o BatchMode=yes "$SERVER_USER@$SERVER_IP" "echo 'SSH connection OK'"

echo "=== 2. Testing passwordless sudo ==="
ssh -i "$KEY_PATH" "$SERVER_USER@$SERVER_IP" "sudo -n whoami"

echo "=== 3. Testing application directory creation ==="
ssh -i "$KEY_PATH" "$SERVER_USER@$SERVER_IP" "sudo mkdir -p /var/www/html/tp-app && echo 'Directory created OK'"

echo "=== 4. Checking available system services ==="
ssh -i "$KEY_PATH" "$SERVER_USER@$SERVER_IP" "systemctl list-units --type=service --state=running | head -n 5"

echo "=== All local validation tests passed ==="
