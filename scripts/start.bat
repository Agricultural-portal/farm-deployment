@echo off
REM ==============================================================================
REM Quick Start Script (Windows)
REM ==============================================================================

echo Starting Farm Connect Application...

REM Check Docker
docker --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker is not installed or not running!
    exit /b 1
)

REM Start services
docker-compose up -d

echo.
echo Application is starting...
echo Frontend: http://localhost
echo Backend API: http://localhost/api
echo.
echo To view logs: docker-compose logs -f
echo To stop: docker-compose down
