# LEMP Dev Stack - Quick Start

This is a general-purpose LEMP stack for local development, with phpMyAdmin as the primary database management tool.

## Quick Commands

```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# Access phpMyAdmin
# Open: http://localhost:8080
# Default credentials from .env file

# Access web projects
# Open: http://localhost/
# Add your projects to ./webroot/

# Access MariaDB from host
# Host: localhost
# Port: 3306
# Credentials from .env file
```

## Files to Edit

1. **`.env`** - Configure ports, passwords, and settings
2. **`./data/*.sql`** - Add SQL files for auto-import
3. **`./webroot/`** - Add your PHP projects
4. **`./nginx/sites-enabled/`** - Add project-specific configs

## Default URLs

| Service | URL |
|---------|-----|
| phpMyAdmin | http://localhost:8080 |
| Web Projects | http://localhost/ |
| MariaDB | localhost:3306 |

## Common Tasks

### Add a new project
1. Copy project files to `./webroot/project-name/`
2. Visit `http://localhost/project-name/` or configure nginx

### Create new database
1. Login to phpMyAdmin at `http://localhost:8080`
2. Click "New" in the left sidebar
3. Enter database name and click "Create"

### Import database from SQL file
1. Place `.sql` file in `./data/` folder
2. Restart containers: `docker-compose restart mariadb`
3. Or import via phpMyAdmin interface

### Enable Xdebug
1. Edit `.env`: `PHP_XDEBUG_ENABLED=true`
2. Restart containers: `docker-compose restart`

### Change ports
1. Edit `.env`: Change port numbers
2. Restart containers: `docker-compose down && docker-compose up -d`

---

**Note**: Since your primary usage is phpMyAdmin + MySQL management, most interactions will be through `http://localhost:8080` (phpMyAdmin) and database access via `localhost:3306`.
