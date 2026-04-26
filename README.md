# LEMP Development Stack

A lightweight, containerized development environment built on the LEMP stack: Nginx, PHP-FPM, and MariaDB. Designed for local development using Docker, it provides a fast, isolated, and reproducible backend setup with minimal overhead.

## 🚀 Features

- **Nginx** - Lightweight reverse proxy with HTTP/2, SSL, and gzip support.
- **PHP 8.2-FPM** - FastCGI processor with Xdebug and common extensions.
- **phpMyAdmin** - Database management interface.
- **MariaDB 11** - Modern database server.
- **Xdebug** - PHP debugger (optional, configurable via `.env`).
- **SQL Auto-Import** - Automatically imports `.sql` files from the `data/` folder on first startup.
- **Management Script** - A powerful helper script (`lemp.sh`) to manage the entire stack.

## 🛠️ Requirements

- Docker (v20+)
- Docker Compose (v2+)

## 📦 Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url> lemp-dev-stack
   cd lemp-dev-stack
   ```

2. **Configure environment:**
   ```bash
   cp .env.example .env
   ```
   *Edit `.env` to change default passwords or ports.*

3. **Prepare the management script:**
   ```bash
   chmod +x lemp.sh
   ```

4. **Start the stack:**
   ```bash
   ./lemp.sh start
   ```

## 🎮 Usage (Management Script)

Instead of raw Docker commands, use the `lemp.sh` script for easier management:

| Command | Description |
| :--- | :--- |
| `./lemp.sh start` | Start all containers in detached mode |
| `./lemp.sh stop` | Stop and remove containers |
| `./lemp.sh restart` | Restart the entire stack |
| `./lemp.sh status` | Show current container status |
| `./lemp.sh logs` | Follow container logs in real-time |
| `./lemp.sh verify` | Verify if services are online and responding |
| `./lemp.sh build` | Rebuild Docker images |
| `./lemp.sh update` | Pull latest images and restart |
| `./lemp.sh clean` | Prune unused Docker containers, images, and networks |
| `./lemp.sh clean-vols` | Stop stack and remove all volumes (Warning: Deletes DB data) |

### Executing Commands in Containers
- **Open a shell:** `./lemp.sh shell [container_name]` (e.g., `./lemp.sh shell phpfpm`)
- **Run a command:** `./lemp.sh exec [container_name] [command]` (e.g., `./lemp.sh exec phpfpm php -v`)

## 🌐 Services & Access

| Service | URL | Default Credentials |
| :--- | :--- | :--- |
| **Nginx (Projects)** | `http://localhost/` | Projects in `webroot/` |
| **phpMyAdmin** | `http://localhost:8080` | `root` / `${MYSQL_ROOT_PASSWORD}` |
| **MariaDB** | `localhost:3306` | `${MYSQL_USER}` / `${MYSQL_PASSWORD}` |

## ⚙️ Configuration

### Environment Variables (`.env`)

| Variable | Default | Description |
| :--- | :--- | :--- |
| `MYSQL_ROOT_PASSWORD` | `lemp_root_password` | Root password for MariaDB |
| `MYSQL_DATABASE` | `lemp_db` | Initial database to create |
| `MYSQL_USER` | `lemp_user` | Default database user |
| `MYSQL_PASSWORD` | `lemp_password` | Password for default user |
| `MYSQL_PORT` | `3306` | MariaDB host port |
| `NGINX_PORT` | `80` | Nginx host port |
| `PHPMYADMIN_PORT` | `8080` | phpMyAdmin host port |
| `PHP_XDEBUG_ENABLED` | `false` | Enable Xdebug (true/false) |

### Custom Nginx Sites
Add your project configurations in `nginx/sites-enabled/`. Example:
```nginx
server {
    listen 80;
    server_name project.local;
    root /var/www/html/project;
    
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    
    location ~ \.php$ {
        fastcgi_pass phpfpm:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
```

## 📂 Project Structure

```
lemp-dev-stack/
├── docker-compose.yml      # Service definitions
├── lemp.sh                 # Management script
├── .env                    # Configuration
├── nginx/                  # Nginx config & site definitions
├── php/                    # PHP-FPM Dockerfile & settings
├── mysql/                  # MariaDB Dockerfile
├── data/                   # SQL files for auto-import
└── webroot/                # Your project files
```

## 🔍 Advanced Features

### SQL Import
Place any `.sql` files in the `data/` folder. MariaDB will automatically import them in alphabetical order during the first startup.

### Xdebug Setup
1. Set `PHP_XDEBUG_ENABLED=true` in `.env`.
2. Ensure your IDE (VS Code/PHPStorm) is listening on port `9003`.
3. Use `host.docker.internal` as the remote host.

## 📄 License
MIT License - See `LICENSE` file for details.
