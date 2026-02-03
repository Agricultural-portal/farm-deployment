# 🔧 Quick Reference - Farm Connect Deployment

## Essential Commands

### Docker Compose

```bash
# Start all services
docker-compose up -d

# Start with rebuild
docker-compose up -d --build

# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v

# View logs (all services)
docker-compose logs -f

# View logs (specific service)
docker-compose logs -f backend

# Check service status
docker-compose ps

# Restart service
docker-compose restart backend

# Scale service
docker-compose up -d --scale backend=3
```

### Individual Services

```bash
# Backend only
docker-compose up -d mysql backend

# Frontend only  
docker-compose up -d frontend

# Database only
docker-compose up -d mysql
```

### Database Operations

```bash
# Backup database
docker exec farm-mysql mysqldump -u root -p farm_backend > backup.sql

# Restore database
docker exec -i farm-mysql mysql -u root -p farm_backend < backup.sql

# Connect to MySQL
docker exec -it farm-mysql mysql -u root -p

# View database logs
docker-compose logs mysql
```

### Docker Management

```bash
# Remove all stopped containers
docker container prune

# Remove unused images
docker image prune -a

# Remove unused volumes
docker volume prune

# Clean everything
docker system prune -a --volumes

# View disk usage
docker system df

# View resource usage
docker stats
```

## URLs

| Service | URL | Description |
|---------|-----|-------------|
| Frontend | http://localhost | Main application |
| Backend API | http://localhost/api | REST API endpoints |
| Nginx Health | http://localhost/nginx-health | Nginx status |
| Backend Health | http://localhost/api/health | Backend health check |
| MySQL | localhost:3306 | Database (external access) |

## Environment Variables

### Required for Production

```env
# Database
MYSQL_ROOT_PASSWORD=<strong-password>
MYSQL_USER=farm_user
MYSQL_PASSWORD=<mysql-password>

# Security
JWT_SECRET=<256-bit-secret>

# Cloudinary
CLOUDINARY_CLOUD_NAME=<your-cloud>
CLOUDINARY_API_KEY=<your-key>
CLOUDINARY_API_SECRET=<your-secret>

# Weather API
WEATHER_API_KEY=<openweather-key>
```

## GitHub Secrets

Set in: Repository → Settings → Secrets and variables → Actions

| Secret | Purpose |
|--------|---------|
| `DOCKER_USERNAME` | Docker Hub username |
| `DOCKER_PASSWORD` | Docker Hub token |
| `SSH_PRIVATE_KEY` | Server SSH key |
| `SERVER_HOST` | Production server IP |
| `SERVER_USER` | SSH username |

## Deployment Steps

### Initial Setup

1. **Clone repository**
   ```bash
   git clone <repo-url>
   cd final_dac_project
   ```

2. **Configure environment**
   ```bash
   cp .env.example .env.production
   # Edit .env.production with your values
   ```

3. **Deploy**
   ```bash
   docker-compose up -d --build
   ```

### Updates

1. **Pull latest code**
   ```bash
   git pull origin main
   ```

2. **Rebuild and restart**
   ```bash
   docker-compose down
   docker-compose up -d --build
   ```

## Troubleshooting

### Port Already in Use

```bash
# Find process using port
netstat -ano | findstr :80    # Windows
lsof -i :80                   # Linux/Mac

# Kill process
taskkill /PID <pid> /F        # Windows
kill -9 <pid>                 # Linux/Mac
```

### Service Won't Start

```bash
# Check logs
docker-compose logs <service-name>

# Check status
docker-compose ps

# Force rebuild
docker-compose build --no-cache <service-name>
docker-compose up -d <service-name>
```

### Clear Everything

```bash
# Nuclear option - clean slate
docker-compose down -v
docker system prune -a --volumes
docker-compose up -d --build
```

## Health Check Commands

```bash
# Check Nginx
curl http://localhost/nginx-health

# Check Backend
curl http://localhost/api/health

# Check Frontend
curl http://localhost/health

# Check all at once
curl -s http://localhost/nginx-health && \
curl -s http://localhost/api/health && \
echo "All services healthy!"
```

## Backup Strategy

### Automated Backup (Cron Job)

```bash
# Add to crontab (daily at 2 AM)
0 2 * * * cd /path/to/project && ./scripts/backup.sh

# Edit crontab
crontab -e
```

### Manual Backup

```bash
./scripts/backup.sh

# Backups saved to: backups/farm_backend_YYYYMMDD_HHMMSS.sql.gz
```

## Monitoring

### View Live Logs

```bash
# All services
docker-compose logs -f

# Last 100 lines
docker-compose logs --tail=100

# Specific service since timestamp
docker-compose logs --since 2h backend
```

### Check Resource Usage

```bash
# Real-time stats
docker stats

# Container disk usage
docker system df

# Detailed info
docker inspect <container-name>
```

## Common Issues

| Issue | Solution |
|-------|----------|
| Port 80 in use | Change port in docker-compose.yml or stop conflicting service |
| Database connection failed | Check MySQL is running: `docker-compose ps mysql` |
| Backend 502 error | Check backend logs: `docker-compose logs backend` |
| Out of disk space | Run `docker system prune -a --volumes` |
| Container keeps restarting | Check logs: `docker-compose logs <service>` |
| Permission denied | Run with sudo or add user to docker group |

## Performance Tuning

### Docker

```yaml
# In docker-compose.yml, add resource limits:
services:
  backend:
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 1G
        reservations:
          memory: 512M
```

### MySQL

```bash
# Increase buffer pool size
# Add to docker-compose.yml mysql command:
command: --innodb-buffer-pool-size=1G --max-connections=200
```

### Nginx

```nginx
# In nginx.conf
worker_processes auto;
worker_connections 2048;
```

## Security Checklist

- [ ] Changed default passwords
- [ ] Using strong JWT secret (256+ bits)
- [ ] SSL/HTTPS enabled (production)
- [ ] Firewall configured
- [ ] Database not publicly accessible
- [ ] Environment variables secure
- [ ] Regular backups enabled
- [ ] Logs monitored
- [ ] Rate limiting active
- [ ] Security headers configured

---

**Quick Help**: Run `./scripts/logs.sh` for interactive log viewer
