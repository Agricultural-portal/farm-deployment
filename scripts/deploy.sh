#!/bin/bash

# ==============================================================================
# Deployment Script for Farm Connect Application
# ==============================================================================

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if .env.production exists
if [ ! -f .env.production ]; then
    print_error ".env.production file not found!"
    print_info "Please create it from .env.example and fill in the values"
    exit 1
fi

# Load environment variables
export $(cat .env.production | grep -v '^#' | xargs)

print_info "Starting deployment..."

# Stop existing containers
print_info "Stopping existing containers..."
docker-compose down

# Pull latest changes (if this script is run on server)
# print_info "Pulling latest changes from git..."
# git pull origin main

# Build images
print_info "Building Docker images..."
docker-compose build --no-cache

# Start containers
print_info "Starting containers..."
docker-compose up -d

# Wait for services to be healthy
print_info "Waiting for services to be healthy..."
sleep 10

# Check health
print_info "Checking service health..."
docker-compose ps

# Test endpoints
print_info "Testing endpoints..."
sleep 20

if curl -f http://localhost/nginx-health > /dev/null 2>&1; then
    print_info "✓ Nginx is healthy"
else
    print_warning "✗ Nginx health check failed"
fi

if curl -f http://localhost/api/health > /dev/null 2>&1; then
    print_info "✓ Backend is healthy"
else
    print_warning "✗ Backend health check failed"
fi

# Show logs
print_info "Recent logs:"
docker-compose logs --tail=50

print_info "Deployment complete!"
print_info "Access the application at: http://localhost"
