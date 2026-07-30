#!/usr/bin/env bash
set -e

# Visual colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Starting Oracle Purpur Minecraft Server Setup ===${NC}"

# 1. Update packages and install dependencies
echo -e "${GREEN}[1/6] Installing Java 21, screen, ufw, and curl...${NC}"
sudo apt update && sudo apt upgrade -y
sudo apt install -y openjdk-21-jre-headless screen ufw wget curl jq

# 2. Configure Ubuntu UFW Firewall
echo -e "${GREEN}[2/6] Configuring firewall ports (25565)...${NC}"
sudo ufw allow 25565/tcp
sudo ufw allow 25565/udp
sudo ufw --force enable

# 3. Create server directory
echo -e "${GREEN}[3/6] Setting up server directory...${NC}"
SERVER_DIR="$HOME/purpur-server"
mkdir -p "$SERVER_DIR"
cd "$SERVER_DIR"

# 4. Prompts for Server Customization
echo -e "${GREEN}[4/6] Customizing Server Setup...${NC}"
LATEST_VER=$(curl -s https://api.purpurmc.org/v2/purpur | grep -oP '"\K[0-9.]+(?=")' | tail -1)

echo -e "${CYAN}---------------------------------------------------${NC}"
read -p "$(echo -e ${YELLOW}"Enter Server Name / MOTD [Default: My Purpur Server]: "${NC})" SERVER_NAME
read -p "$(echo -e ${YELLOW}"Enter Minecraft Version [Press Enter for latest: ${LATEST_VER}]: "${NC})" USER_VER
echo -e "${CYAN}---------------------------------------------------${NC}"

# Set default values if inputs are empty
if [ -z "$SERVER_NAME" ]; then
  SERVER_NAME="My Purpur Server"
fi

if [ -z "$USER_VER" ]; then
  USER_VER=$LATEST_VER
fi

# 5. Download Purpur
echo -e "${GREEN}[5/6] Downloading Purpur version: ${USER_VER}...${NC}"
wget -O server.jar "https://api.purpurmc.org/v2/purpur/${USER_VER}/latest/download"

# 6. Accept EULA and set configuration
echo -e "${GREEN}[6/6] Pre-configuring EULA and server.properties...${NC}"
echo "eula=true" >eula.txt

# Run once briefly to generate default server.properties, then patch it
java -Xms1G -Xmx2G -jar server.jar nogui || true

if [ -f "server.properties" ]; then
  # Set offline-mode
  sed -i 's/online-mode=true/online-mode=false/g' server.properties
  # Set custom MOTD / Server Name
  sed -i "s/^motd=.*/motd=${SERVER_NAME}/g" server.properties
fi

# Create startup script
cat <<'EOF' >start.sh
#!/usr/bin/env bash
screen -S minecraft java -Xms4G -Xmx12G -jar server.jar nogui
EOF

chmod +x start.sh

echo -e "${GREEN}=== Setup Complete! ===${NC}"
echo -e "Server Name: ${CYAN}${SERVER_NAME}${NC}"
echo -e "Minecraft Version: ${CYAN}${USER_VER}${NC}"
echo -e "Server Directory: ${SERVER_DIR}"
echo -e "To start your server, run:"
echo -e "  cd ~/purpur-server && ./start.sh"
