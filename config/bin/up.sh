#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

PORT=80
IP=""
INTERFACE=""

print_banner() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}       Levantando Servidor HTTP en Puerto ${PORT}${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}\n"
}

pick_ip() {
    local iface
    for iface in tun0 wlan0; do
        IP="$(ip -4 -o addr show dev "$iface" 2>/dev/null | awk '{print $4}' | cut -d/ -f1 | head -n1)"
        if [[ -n "$IP" ]]; then
            INTERFACE="$iface"
            return
        fi
    done

    echo -e "${RED}✗ No se encontro IP en tun0 ni en wlan0${NC}"
    exit 1
}

free_port() {
    local pids
    pids="$(lsof -tiTCP:${PORT} -sTCP:LISTEN 2>/dev/null || true)"

    if [[ -z "$pids" ]]; then
        echo -e "${GREEN}✓ Puerto ${PORT} disponible${NC}"
        return
    fi

    echo -e "${YELLOW}⚠ Puerto ${PORT} en uso, liberando...${NC}"
    sudo kill $pids 2>/dev/null || sudo kill -9 $pids 2>/dev/null || {
        echo -e "${RED}✗ No se pudo liberar el puerto ${PORT}${NC}"
        exit 1
    }
    sleep 1
    echo -e "${GREEN}✓ Puerto ${PORT} liberado${NC}"
}

start_server() {
    echo -e "\n${GREEN}✓ IP detectada en ${INTERFACE}: ${YELLOW}${IP}${NC}"
    echo -e "${BLUE}Acceso disponible en:${NC} ${GREEN}http://${IP}${NC}\n"
    echo -e "${BLUE}Iniciando servidor HTTP...${NC}\n"
    exec sudo python3 -m http.server "${PORT}"
}

print_banner
pick_ip
free_port
start_server
