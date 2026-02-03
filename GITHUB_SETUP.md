# ✅ GitHub Repository Setup Checklist

Complete this checklist to set up your GitHub repository for CI/CD deployment.

## 📋 Pre-Deployment Checklist

### 1. Repository Setup

- [ ] Create GitHub repository (or use existing)
- [ ] Push code to repository
  ```bash
  git init
  git add .
  git commit -m "Initial commit with Docker and CI/CD setup"
  git branch -M main
  git remote add origin <your-repo-url>
  git push -u origin main
  ```

### 2. Environment Configuration

- [ ] Copy `.env.example` to `.env.production`
- [ ] Fill in all required values in `.env.production`
- [ ] Verify `.env.production` is in `.gitignore`
- [ ] Test locally with: `docker-compose --env-file .env.production up -d`

### 3. Docker Hub Setup

- [ ] Create Docker Hub account at https://hub.docker.com
- [ ] Create repository for backend: `<username>/farm-backend`
- [ ] Create repository for frontend: `<username>/farm-frontend`
- [ ] Create repository for nginx: `<username>/farm-nginx`
- [ ] Generate access token: Account Settings → Security → New Access Token
- [ ] Copy access token (you'll need it for GitHub Secrets)

### 4. GitHub Secrets Configuration

Go to: **Repository → Settings → Secrets and variables → Actions → New repository secret**

#### Required Secrets:

- [ ] **DOCKER_USERNAME**
  - Description: Your Docker Hub username
  - Example: `johndoe`

- [ ] **DOCKER_PASSWORD**
  - Description: Docker Hub access token (NOT your password)
  - Example: `dckr_pat_abc123...`

#### Optional Secrets (for Auto-Deployment to Server):

- [ ] **SSH_PRIVATE_KEY**
  - Description: SSH private key for server access
  - Generate with: `ssh-keygen -t ed25519 -C "github-actions"`
  - Copy private key content
  - Add public key to server: `~/.ssh/authorized_keys`

- [ ] **SERVER_HOST**
  - Description: Production server IP or domain
  - Example: `192.168.1.100` or `farm.yourdomain.com`

- [ ] **SERVER_USER**
  - Description: SSH username for server
  - Example: `ubuntu` or `admin`

### 5. Server Setup (If Auto-Deploying)

On your production server:

- [ ] Install Docker
  ```bash
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  ```

- [ ] Install Docker Compose
  ```bash
  sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  ```

- [ ] Create application directory
  ```bash
  mkdir -p ~/farm-app
  cd ~/farm-app
  ```

- [ ] Add GitHub Actions public key to server
  ```bash
  # On server, add the public key from step 4 to:
  nano ~/.ssh/authorized_keys
  ```

- [ ] Create `.env` file on server
  ```bash
  # Copy your .env.production to server
  nano ~/farm-app/.env.production
  ```

- [ ] Test SSH connection from local
  ```bash
  ssh -i <private-key> <user>@<server-ip>
  ```

### 6. Workflow Configuration

- [ ] Review `.github/workflows/ci-cd.yml`
- [ ] Update Docker image names if needed (line 10-12)
- [ ] Enable GitHub Actions: Repository → Actions → Enable workflows
- [ ] Check workflow runs: Repository → Actions

### 7. Testing CI/CD

- [ ] Make a small change to code
- [ ] Commit and push to `main` branch
  ```bash
  git add .
  git commit -m "Test CI/CD pipeline"
  git push origin main
  ```
- [ ] Go to GitHub → Actions → Watch workflow run
- [ ] Check for build success
- [ ] Verify Docker images pushed to Docker Hub
- [ ] Check server deployment (if configured)

### 8. DNS & SSL (Production Only)

- [ ] Point domain to server IP
- [ ] Install Certbot on server
  ```bash
  sudo apt install certbot python3-certbot-nginx
  ```
- [ ] Generate SSL certificate
  ```bash
  sudo certbot --nginx -d yourdomain.com
  ```
- [ ] Update `nginx/nginx.conf` with SSL configuration
- [ ] Test SSL: https://yourdomain.com

### 9. Monitoring & Alerts

- [ ] Set up log monitoring
- [ ] Configure backup automation (cron job)
  ```bash
  crontab -e
  # Add: 0 2 * * * cd /path/to/project && ./scripts/backup.sh
  ```
- [ ] Set up health check monitoring (optional)
  - UptimeRobot, Pingdom, or similar

- [ ] Configure notification service (optional)
  - Slack webhook
  - Discord webhook  
  - Email alerts

### 10. Security Hardening

- [ ] Change all default passwords
- [ ] Use strong JWT secret (min 256 bits)
  ```bash
  # Generate with:
  openssl rand -base64 64
  ```
- [ ] Configure firewall
  ```bash
  sudo ufw allow 22/tcp  # SSH
  sudo ufw allow 80/tcp  # HTTP
  sudo ufw allow 443/tcp # HTTPS
  sudo ufw enable
  ```
- [ ] Restrict MySQL access (not public)
- [ ] Enable rate limiting in Nginx
- [ ] Review security headers in nginx.conf
- [ ] Set up regular security updates
  ```bash
  sudo apt update && sudo apt upgrade -y
  ```

## 🚀 Deployment Commands

### First Deployment

```bash
# On server
cd ~/farm-app

# Pull code (or upload docker-compose.yml)
git clone <repo-url> .

# Create environment file
cp .env.example .env.production
nano .env.production

# Deploy
docker-compose --env-file .env.production up -d --build
```

### Update Deployment

```bash
# On server
cd ~/farm-app
git pull origin main
docker-compose down
docker-compose --env-file .env.production up -d --build
```

### Using CI/CD (Automatic)

Just push to main branch:
```bash
git add .
git commit -m "Your changes"
git push origin main
```

GitHub Actions will automatically:
1. Build and test code
2. Build Docker images
3. Push to Docker Hub
4. Deploy to server (if configured)

## 📊 Verification

### After Setup, Verify:

- [ ] GitHub Actions workflow completes successfully
- [ ] Docker images appear in Docker Hub
- [ ] Application accessible at http://localhost or domain
- [ ] Backend API responds: `curl http://localhost/api/health`
- [ ] Frontend loads: `curl http://localhost`
- [ ] Nginx proxy works: `curl http://localhost/nginx-health`
- [ ] Database connection works (check backend logs)
- [ ] SSL certificate valid (production only)

### Health Checks

```bash
# All services healthy
docker-compose ps

# Check logs
docker-compose logs -f

# API health
curl http://localhost/api/health

# Should return:
# {"status":"UP"}
```

## 🐛 Troubleshooting

### CI/CD Pipeline Fails

1. Check GitHub Actions logs: Repository → Actions → Click failed workflow
2. Verify all secrets are set correctly
3. Check Docker Hub credentials
4. Verify SSH access to server (if deploying)

### Docker Push Fails

- Verify `DOCKER_USERNAME` and `DOCKER_PASSWORD` secrets
- Check Docker Hub token hasn't expired
- Ensure repository names match in workflow file

### SSH Deployment Fails

- Verify `SSH_PRIVATE_KEY` format (should be complete private key)
- Check `SERVER_HOST` and `SERVER_USER` are correct
- Test SSH manually: `ssh -i key user@host`
- Ensure server has Docker and docker-compose installed

### Health Checks Fail

- Check service logs: `docker-compose logs <service>`
- Verify environment variables are set
- Check database connection
- Ensure ports aren't blocked

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/actions)
- [Docker Hub](https://hub.docker.com)
- [Let's Encrypt SSL](https://letsencrypt.org)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## ✅ Final Checklist

Before going to production:

- [ ] All secrets configured in GitHub
- [ ] Docker images build successfully
- [ ] CI/CD pipeline runs without errors
- [ ] Application tested locally
- [ ] Database backup script works
- [ ] SSL certificate installed (production)
- [ ] Firewall configured
- [ ] Monitoring set up
- [ ] Documentation reviewed
- [ ] Team trained on deployment process

---

**Status**: [ ] Not Started | [ ] In Progress | [ ] ✅ Complete

**Last Updated**: _________________

**Deployed By**: _________________
