# LEMP Management Script

A convenient shell script for managing your LEMP development stack.

## Installation

Copy the script to a directory in your PATH:

```bash
cp lemp.sh /usr/local/bin/lemp
chmod +x /usr/local/bin/lemp
```

Or run it from the project directory:

```bash
./lemp.sh
```

## Usage

```
lemp.sh [command] [options]
```

### Commands

| Command | Description |
|---------|-------------|
| `start [OPTIONS]` | Start containers |
| `stop` | Stop containers |
| `restart [OPTIONS]` | Restart containers |
| `status` | Show container status |
| `logs [OPTIONS]` | Show container logs |
| `exec [container] [cmd]` | Execute command in container |
| `shell [container]` | Open shell in container |
| `update` | Update and restart containers |
| `build [OPTIONS]` | Build images |
| `clean` | Clean Docker environment |
| `clean-volumes` | Clean Docker volumes (deletes data!) |
| `help` | Show help |

### Options

- `--build` - Build images before starting/restarting
- `--no-cache` - Build without cache
- `-f` - Follow logs

## Examples

```bash
# Start containers
lemp.sh start

# Build and start containers
lemp.sh start --build

# View logs in real-time
lemp.sh logs -f

# Open shell in phpMyAdmin container
lemp.sh shell phpmyadmin

# Execute command in specific container
lemp.sh exec phpfpm php -v

# Restart with rebuild
lemp.sh restart --build

# Update to latest images
lemp.sh update

# Clean Docker environment
lemp.sh clean

# Clean Docker volumes (WARNING: deletes all data!)
lemp.sh clean-volumes
```

## Available Services

| Container | Service | URL |
|-----------|---------|-----|
| `nginx` | Web Server | http://localhost |
| `phpmyadmin` | Database Management | http://localhost:8080 |
| `phpfpm` | PHP Processor | Internal only |
| `mariadb` | Database | localhost:3306 |

## Requirements

- Docker (v20+)
- Docker Compose (v2+) or Docker with Compose V2
- Bash (v4+)

## License

MIT License - See LICENSE file for details.
