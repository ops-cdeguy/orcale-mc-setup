# 🚀 Oracle Cloud Purpur Minecraft Server Setup

An automated Bash script to spin up a high-performance Purpur Minecraft Server on **Ubuntu 24.04 / 22.04 LTS** (optimized for Oracle Cloud ARM instances). It automatically fetches the absolute latest Purpur version dynamically.

## ✨ Features

- Installs **Java 21** and essential Linux tools (`screen`, `ufw`, `curl`, `jq`).
- Opens required game ports (`25565` TCP/UDP) in `ufw`.
- Dynamically fetches and downloads the latest Purpur build directly from their API.
- Pre-accepts the Minecraft EULA.
- Configures `online-mode=false` for offline-mode setups.
- Generates a single-command startup script (`start.sh`) running inside a persistent `screen` session.

---

## ⚡ Quick Start

SSH into your Ubuntu VM and run this single command:

```bash
git clone [https://github.com/ops-cdeguy/orcale-mc-setup.git](https://github.com/ops-cdeguy/orcale-mc-setup.git)
cd orcale-mc-setup
chmod +x setup.sh
./setup.sh
```

---

## 🎮 How to Start the Server

Once the script finishes:

```bash
cd ~/purpur-server
./start.sh
```

### Server Management

- **View Server Console:** `screen -r minecraft`
- **Detach from Console:** Press `Ctrl + A`, then `D`.
- **Stop Server:** Enter `stop` directly in the server console session.
- **Update Server:** Run `./update.sh` from this repository to pull the newest Purpur `.jar`.

> **Note for Oracle Cloud Users:** Make sure to also add an **Ingress Rule** for Port `25565` (TCP/UDP) in your Oracle Cloud Console under _Networking -> Virtual Cloud Networks -> Default Security List -> Ingress Rules_.
