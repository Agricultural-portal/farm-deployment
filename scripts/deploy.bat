@echo off
REM ==============================================================================
REM Deployment Script for Farm Connect Application (Windows)
REM ==============================================================================

echo [INFO] Starting deployment...

REM Check if .env.production exists
if not exist .env.production (
    echo [ERROR] .env.production file not found!
    echo [INFO] Please create it from .env.example and fill in the values
    exit /b 1
)

REM Stop existing containers
echo [INFO] Stopping existing containers...
docker-compose down

REM Build images
echo [INFO] Building Docker images...
docker-compose build --no-cache

REM Start containers
echo [INFO] Starting containers...
docker-compose up -d

REM Wait for services
echo [INFO] Waiting for services to start...
timeout /t 30 /nobreak

REM Check status
echo [INFO] Checking service status...
docker-compose ps

REM Show logs
echo [INFO] Recent logs:
docker-compose logs --tail=50

echo [INFO] Deployment complete!
echo [INFO] Access the application at: http://localhost
