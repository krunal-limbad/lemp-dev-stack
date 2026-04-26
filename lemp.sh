#!/bin/bash

# LEMP Development Stack Management Script
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

LEMP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="${LEMP_DIR}/docker-compose.yml"

check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Error: Docker is not installed"
        exit 1
    fi
}

get_compose_cmd() {
    if command -v docker-compose &> /dev/null; then
        docker-compose -f "$COMPOSE_FILE" "$@"
    else
        docker compose -f "$COMPOSE_FILE" "$@"
    fi
}

start() {
    check_docker
    echo -e "${BLUE}Starting LEMP stack...${NC}"
    get_compose_cmd up -d
    echo -e "${GREEN}✓ Containers started${NC}"
    verify
}

stop() {
    check_docker
    echo -e "${BLUE}Stopping LEMP stack...${NC}"
    get_compose_cmd down
    echo -e "${GREEN}✓ Containers stopped${NC}"
}

restart() {
    check_docker
    echo -e "${BLUE}Restarting LEMP stack...${NC}"
    get_compose_cmd down
    get_compose_cmd up -d
    echo -e "${GREEN}✓ Containers restarted${NC}"
}

status() {
    check_docker
    echo -e "${BLUE}Container status:${NC}"
    get_compose_cmd ps
}

logs() {
    check_docker
    echo -e "${BLUE}Starting logs... (Ctrl+C to exit)${NC}"
    get_compose_cmd logs -f
}

exec() {
    check_docker
    if [[ -z "$1" ]]; then
        echo "Usage: lemp exec [container] [command]"
        get_compose_cmd ps
        exit 1
    fi
    get_compose_cmd exec "$@"
}

shell() {
    check_docker
    if [[ -z "$1" ]]; then
        echo "Usage: lemp shell [container]"
        get_compose_cmd ps
        exit 1
    fi
    get_compose_cmd exec -T "$1" /bin/sh
}

update() {
    check_docker
    echo -e "${BLUE}Updating LEMP stack...${NC}"
    get_compose_cmd pull
    get_compose_cmd down
    get_compose_cmd up -d
    echo -e "${GREEN}✓ LEMP stack updated${NC}"
}

build() {
    check_docker
    echo -e "${BLUE}Building images...${NC}"
    get_compose_cmd build
    echo -e "${GREEN}✓ Build complete${NC}"
}

clean() {
    check_docker
    echo -e "${BLUE}Cleaning Docker environment...${NC}"
    docker container prune -f
    docker image prune -a -f
    docker volume prune -f
    docker network prune -f
    echo -e "${GREEN}✓ Cleanup complete${NC}"
}

clean-volumes() {
    check_docker
    echo -e "${BLUE}Cleaning volumes...${NC}"
    get_compose_cmd down -v
    echo -e "${GREEN}✓ Volumes cleaned${NC}"
}

help() {
    echo "LEMP Development Stack - Management Script"
    echo
    echo "Commands:"
    echo "  start       - Start containers"
    echo "  stop        - Stop containers"
    echo "  restart     - Restart containers"
    echo "  status      - Show container status"
    echo "  logs        - Show container logs (follow mode)"
    echo "  exec [container] [cmd]  - Execute command in container"
    echo "  shell [container]       - Open shell in container"
    echo "  update      - Update to latest images"
    echo "  build       - Build images"
    echo "  clean       - Clean Docker environment"
    echo "  clean-vols  - Clean Docker volumes"
    echo "  help        - Show this help"
}
verify() {
    check_docker
    echo -e "${BLUE}Verifying LEMP stack...${NC}"
    
    # Check containers
    get_compose_cmd ps
    
    # Check Nginx
    if curl -s --head http://localhost | grep "200 OK" > /dev/null; then
        echo -e "${GREEN}✓ Web Server: Online (http://localhost)${NC}"
    else
        echo -e "${BLUE}✗ Web Server: Offline or Not Responding${NC}"
    fi
    
    # Check phpMyAdmin
    if curl -s --head http://localhost:8080 | grep "200 OK" > /dev/null; then
        echo -e "${GREEN}✓ phpMyAdmin: Online (http://localhost:8080)${NC}"
    else
        echo -e "${BLUE}✗ phpMyAdmin: Offline or Not Responding${NC}"
    fi
    
    # Check PHP
    if get_compose_cmd exec phpfpm php -v | grep "PHP" > /dev/null; then
        echo -e "${GREEN}✓ PHP-FPM: Working${NC}"
    else
        echo -e "${BLUE}✗ PHP-FPM: Error executing PHP${NC}"
    fi
}

case "$1" in
    start) start ;;
    stop) stop ;;
    restart) restart ;;
    status) status ;;
    logs) logs ;;
    exec) shift; exec "$@" ;;
    shell) shift; shell "$@" ;;
    update) update ;;
    build) build ;;
    verify) verify ;;
    clean) clean ;;
    clean-vols|clean-volumes) clean-volumes ;;
    *) help ;;
esac
