#!/bin/bash
set -e

# Definisi warna untuk output
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
NC="\033[0m"

# Pastikan /usr/local/bin ada di PATH
export PATH=$PATH:/usr/local/bin

echo -e "${BLUE}"
echo "  ______ _____   ___  ____  __________  __ ____  _____ "
echo "  / __/ // / _ | / _ \/ __/ /  _/_  __/ / // / / / / _ )"
echo " _\ \/ _  / __ |/ , _/ _/  _/ /  / /   / _  / /_/ / _  |"
echo "/___/_//_/_/ |_/_/|_/___/ /___/ /_/   /_//_/\____/____/ "
echo -e "${NC}"

echo -e "${BLUE}Mulai proses instalasi...${NC}"
sleep 1

echo -e "${YELLOW}[1/9] Mengupdate dan meng-upgrade sistem...${NC}"
sudo apt update && sudo apt upgrade -y

echo -e "${YELLOW}[2/9] Menginstal Rust dan Cargo...${NC}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

echo -e "${YELLOW}[3/9] Menyisipkan environment Cargo...${NC}"
source "$HOME/.cargo/env"

echo -e "${YELLOW}[4/9] Mengecek versi rustc dan cargo...${NC}"
rustc --version
cargo --version

echo -e "${YELLOW}[5/9] Menambahkan konfigurasi Cargo ke .bashrc...${NC}"
# Hanya tambahkan jika belum ada entri untuk meng-source Cargo environment
if ! grep -q "source \$HOME/.cargo/env" "$HOME/.bashrc"; then
    echo 'source $HOME/.cargo/env' >> "$HOME/.bashrc"
fi
source "$HOME/.bashrc"

echo -e "${YELLOW}[6/9] Menginstal soundnessup...${NC}"
curl -sSL https://raw.githubusercontent.com/soundnesslabs/soundness-layer/main/soundnessup/install | sudo bash

echo -e "${YELLOW}[7/9] Menyegarkan konfigurasi shell...${NC}"
source "$HOME/.bashrc"

# Verifikasi apakah soundnessup dan soundness-cli sudah terinstal dan dapat diakses
if ! command -v soundnessup &>/dev/null; then
    echo -e "${YELLOW}soundnessup tidak ditemukan di PATH. Pastikan instalasi soundnessup berhasil dan direktori instalasinya sudah ditambahkan ke PATH.${NC}"
    exit 1
fi

if ! command -v soundness-cli &>/dev/null; then
    echo -e "${YELLOW}soundness-cli tidak ditemukan di PATH. Pastikan instalasi soundnessup berhasil dengan benar.${NC}"
    exit 1
fi

echo -e "${YELLOW}[8/9] Melakukan instalasi dan update soundnessup...${NC}"
soundnessup install
soundnessup update

echo -e "${YELLOW}[9/9] Membuat key dengan soundness-cli...${NC}"
soundness-cli generate-key --name my-key

echo -e "${GREEN}Instalasi selesai!${NC}"
