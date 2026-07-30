#!/usr/bin/env bash
set -e

# Visual colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SERVER_DIR="$HOME/purpur-server"

echo -e "${YELLOW}=== Updating Purpur Server ===${NC}"

# Ensure server folder exists
if [ ! -d "$SERVER_DIR" ]; then
  echo "Server directory not found! Run setup.sh first."
  exit 1
fi

cd "$SERVER_DIR"

# Backup the current jar
if [ -f "server.jar" ]; then
  mv server.jar server.jar.bak
  echo -e "${GREEN}Created backup: server.jar.bak${NC}"
fi

# Fetch and download the latest Purpur build dynamically
LATEST_VER=$(curl -s https://api.purpurmc.org/v2/purpur | grep -oP '"\K[0-9.]+(?=")' | tail -1)
echo -e "${YELLOW}Downloading latest build for version: ${LATEST_VER}${NC}"
wget -O server.jar "https://api.purpurmc.org/v2/purpur/${LATEST_VER}/latest/download"

echo -e "${GREEN}Update completed! Run ./start.sh to launch.${NC}"
