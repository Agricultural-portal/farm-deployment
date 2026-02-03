#!/bin/bash

# ==============================================================================
# Database Restore Script
# ==============================================================================

set -e

if [ -z "$1" ]; then
    echo "Usage: ./restore.sh <backup_file.sql.gz>"
    echo "Available backups:"
    ls -lh backups/
    exit 1
fi

BACKUP_FILE=$1
CONTAINER_NAME="farm-mysql"

# Load environment variables
if [ -f .env.production ]; then
    export $(cat .env.production | grep -v '^#' | xargs)
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "Backup file not found: $BACKUP_FILE"
    exit 1
fi

echo "Restoring from: $BACKUP_FILE"
echo "WARNING: This will replace all existing data!"
read -p "Are you sure you want to continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Restore cancelled"
    exit 0
fi

# Decompress and restore
echo "Restoring database..."
gunzip -c $BACKUP_FILE | docker exec -i $CONTAINER_NAME mysql \
    -u root \
    -p${MYSQL_ROOT_PASSWORD}

echo "Restore complete!"
