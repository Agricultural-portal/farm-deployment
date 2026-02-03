# 🚀 Farm Connect - Deployment Guide

Complete production deployment setup for Farm Connect application using Docker, Nginx, and CI/CD.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Architecture](#architecture)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [CI/CD Setup](#cicd-setup)
- [Maintenance](#maintenance)
- [Troubleshooting](#troubleshooting)

## 🔧 Prerequisites

### Required Software
- **Docker** >= 20.10
- **Docker Compose** >= 2.0
- **Git**
- **GitHub Account** (for CI/CD)

### System Requirements
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 20GB free space
- **OS**: Linux, macOS, or Windows with WSL2

## 🚀 Quick Start

### 1. Clone Repository
```bash
git clone <your-repo-url>
cd final_dac_project
```

### 2. Configure Environment
```bash
# Copy environment template
cp .env.example .env.production

# Edit with your values
nano .env.production  # or use your favorite editor
```

### 3. Fill Required Environment Variables
Edit `.env.production` with your actual values:
```env
MYSQL_ROOT_PASSWORD=your_secure_password
MYSQL_USER=farm_user
MYSQL_PASSWORD=your_mysql_password
JWT_SECRET=your_jwt_secret_key_256_bits
CLOUDINARY_CLOUD_NAME=your_cloudinary_name
CLOUDINARY_API_KEY=your_cloudinary_key
CLOUDINARY_API_SECRET=your_cloudinary_secret
WEATHER_API_KEY=your_openweather_key
```

### 4. Start Application

**Windows:**
```cmd
scripts\start.bat
```

**Linux/Mac:**
```bash
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```

### 5. Access Application
- **Frontend**: http://localhost
- **Backend API**: http://localhost/api
- **Health Check**: http://localhost/nginx-health

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│          Nginx Reverse Proxy            │
│         (Port 80/443 - SSL)             │
└─────────────┬───────────────────────────┘
              │
      ┌───────┴────────┐
      │                │
      ▼                ▼
┌──────────┐    ┌──────────────┐
│ Frontend │    │   Backend    │
│  React   │    │ Spring Boot  │
│  (Nginx) │    │   (Java 21)  │
│ Port 80  │    │  Port 8080   │
└──────────┘    └───────┬──────┘
                        │
                        ▼
                ┌───────────────┐
                │  MySQL 8.0    │
                │  Port 3306    │
                └───────────────┘
```

### Services

| Service | Container Name | Port | Description |
|---------|---------------|------|-------------|
| Nginx | farm-nginx | 80, 443 | Reverse proxy & load balancer |
| Frontend | farm-frontend | 80 | React app with Vite |
| Backend | farm-backend | 8080 | Spring Boot REST API |
| MySQL | farm-mysql | 3306 | Database |

## ⚙️ Configuration

### Docker Compose Files

- **`docker-compose.yml`** - Production setup
- **`docker-compose.dev.yml`** - Development setup

### Environment Files

- **`.env.example`** - Template with all variables
- **`.env.production`** - Production values (not in git)
- **`backend/Backend/.env`** - Backend dev values
- **`frontend/Frontend/.env.production`** - Frontend build config

### Nginx Configuration

Main config: `nginx/nginx.conf`

**Features:**
- Reverse proxy to backend API
- Static file serving for frontend
- Gzip compression
- Rate limiting
- Security headers
- Health checks

## 🚢 Deployment

### Local Deployment

```bash
# Build and start all services
docker-compose up -d --build

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

### Production Deployment

```bash
# Use production environment file
docker-compose --env-file .env.production up -d --build

# Check service health
docker-compose ps
curl http://localhost/nginx-health
curl http://localhost/api/health
```

### Development Mode

```bash
# Start only database
docker-compose -f docker-compose.dev.yml up -d

# Run backend locally (in backend/Backend)
./mvnw spring-boot:run

# Run frontend locally (in frontend/Frontend)
npm run dev
```

## 🔄 CI/CD Setup

### GitHub Secrets Required

Go to: **Repository → Settings → Secrets and variables → Actions**

Add these secrets:

| Secret Name | Description | Example |
|------------|-------------|---------|
| `DOCKER_USERNAME` | Docker Hub username | `yourusername` |
| `DOCKER_PASSWORD` | Docker Hub password/token | `dckr_pat_...` |
| `SSH_PRIVATE_KEY` | SSH key for server access | `-----BEGIN OPENSSH...` |
| `SERVER_HOST` | Production server IP/domain | `192.168.1.100` |
| `SERVER_USER` | SSH user for server | `ubuntu` |

### Workflows

- **`.github/workflows/ci-cd.yml`** - Main CI/CD pipeline
  - Triggers on push to `main`
  - Builds, tests, and deploys

- **`.github/workflows/build-test.yml`** - Build & test only
  - Triggers on PRs and non-main branches
  - Runs tests without deployment

### Pipeline Stages

1. **Build & Test Backend** - Maven build + JUnit tests
2. **Build & Test Frontend** - npm build + linting
3. **Docker Build & Push** - Build images and push to Docker Hub
4. **Deploy** - SSH to server and deploy
5. **Health Check** - Verify deployment success
6. **Notify** - Send status notifications

## 🛠️ Maintenance

### Database Backup

**Linux/Mac:**
```bash
chmod +x scripts/backup.sh
./scripts/backup.sh
```

**Manual:**
```bash
docker exec farm-mysql mysqldump -u root -p farm_backend > backup.sql
```

### Database Restore

```bash
chmod +x scripts/restore.sh
./scripts/restore.sh backups/farm_backend_20260203_120000.sql.gz
```

### View Logs

**All services:**
```bash
docker-compose logs -f
```

**Specific service:**
```bash
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f nginx
```

**Using script:**
```bash
chmod +x scripts/logs.sh
./scripts/logs.sh
```

### Update Application

```bash
# Pull latest code
git pull origin main

# Rebuild and restart
docker-compose down
docker-compose up -d --build
```

### Scale Services

```bash
# Scale backend to 3 instances
docker-compose up -d --scale backend=3
```

## 🐛 Troubleshooting

### Container Won't Start

```bash
# Check logs
docker-compose logs <service-name>

# Check status
docker-compose ps

# Restart specific service
docker-compose restart <service-name>
```

### Database Connection Issues

```bash
# Check MySQL is running
docker-compose ps mysql

# Check MySQL logs
docker-compose logs mysql

# Connect to MySQL
docker exec -it farm-mysql mysql -u root -p
```

### Port Already in Use

```bash
# Find process using port 80
netstat -ano | findstr :80  # Windows
lsof -i :80                 # Linux/Mac

# Change port in docker-compose.yml
ports:
  - "8080:80"  # Use 8080 instead
```

### Clear Everything and Restart

```bash
# Stop and remove everything
docker-compose down -v

# Remove all images
docker system prune -a

# Rebuild from scratch
docker-compose up -d --build
```

### Backend Can't Connect to Database

1. Check environment variables in `.env.production`
2. Verify MySQL container is healthy: `docker-compose ps`
3. Check backend logs: `docker-compose logs backend`
4. Ensure database URL is correct: `jdbc:mysql://mysql:3306/farm_backend`

### Frontend API Calls Failing

1. Check `VITE_API_URL` in `.env.production` (should be `/api`)
2. Verify Nginx is proxying correctly
3. Check backend is accessible: `curl http://localhost/api/health`
4. Check browser console for CORS errors

### SSL/HTTPS Setup

For production with custom domain:

1. Get SSL certificate (Let's Encrypt recommended)
2. Update `nginx/nginx.conf` with SSL configuration
3. Mount certificates in `docker-compose.yml`
4. Update ports to include 443

## 📊 Monitoring

### Health Checks

- **Nginx**: http://localhost/nginx-health
- **Backend**: http://localhost/api/health
- **Frontend**: http://localhost/health

### Resource Usage

```bash
# View resource usage
docker stats

# View disk usage
docker system df
```

## 🔐 Security Checklist

- [ ] Change all default passwords
- [ ] Use strong JWT secret (256+ bits)
- [ ] Enable SSL/HTTPS in production
- [ ] Configure firewall rules
- [ ] Restrict database access
- [ ] Regular security updates
- [ ] Backup sensitive data
- [ ] Use environment variables for secrets
- [ ] Enable rate limiting
- [ ] Monitor logs for suspicious activity

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [GitHub Actions Documentation](https://docs.github.com/actions)

## 🆘 Support

For issues and questions:
1. Check logs: `docker-compose logs -f`
2. Review this documentation
3. Check GitHub Issues
4. Contact development team

---

**Last Updated**: February 3, 2026
**Version**: 1.0.0
