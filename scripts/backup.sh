#!/bin/bash

# ==============================================================================
# Database Backup Script
# ==============================================================================

set -e

# Configuration
BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
CONTAINER_NAME="farm-mysql"
DB_NAME="farm_backend"

# Load environment variables
if [ -f .env.production ]; then
    export $(cat .env.production | grep -v '^#' | xargs)
fi

# Create backup directory
mkdir -p $BACKUP_DIR

# Backup filename
BACKUP_FILE="$BACKUP_DIR/farm_backend_$DATE.sql"

echo "Creating backup: $BACKUP_FILE"

# Create backup
docker exec $CONTAINER_NAME mysqldump \
    -u root \
    -p${MYSQL_ROOT_PASSWORD} \
    --databases $DB_NAME \
    --single-transaction \
    --quick \
    --lock-tables=false \
    > $BACKUP_FILE

# Compress backup
gzip $BACKUP_FILE

echo "Backup created: ${BACKUP_FILE}.gz"

# Keep only last 7 backups
echo "Cleaning old backups (keeping last 7)..."
ls -t $BACKUP_DIR/farm_backend_*.sql.gz | tail -n +8 | xargs -r rm

echo "Backup complete!"
