#!/bin/bash
set -e

GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
NC="\033[0m" 

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
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sudo sh -s -- -y

echo -e "${YELLOW}[3/9] Menyisipkan environment Cargo...${NC}"
source "$HOME/.cargo/env"

echo -e "${YELLOW}[4/9] Mengecek versi rustc dan cargo...${NC}"
rustc --version
cargo --version

echo -e "${YELLOW}[5/9] Menambahkan konfigurasi Cargo ke .bashrc...${NC}"
echo 'source $HOME/.cargo/env' >> "$HOME/.bashrc"
source "$HOME/.bashrc"

echo -e "${YELLOW}[6/9] Menginstal soundnessup...${NC}"
curl -sSL https://raw.githubusercontent.com/soundnesslabs/soundness-layer/main/soundnessup/install | sudo bash

echo -e "${YELLOW}[7/9] Menyegarkan konfigurasi shell...${NC}"
source "$HOME/.bashrc"

echo -e "${YELLOW}[8/9] Melakukan instalasi dan update soundnessup...${NC}"
soundnessup install
soundnessup update

echo -e "${YELLOW}[9/9] Membuat key dengan soundness-cli...${NC}"
soundness-cli generate-key --name my-key

echo -e "${GREEN}Instalasi selesai!${NC}"
