#!/bin/bash

# Set variables
PG_USER="your_username"         # PostgreSQL username
PG_HOST="your_host"             # PostgreSQL host (e.g., localhost or IP)
PG_DB="your_database"           # Database name
PG_PASSWORD="your_password"     # PostgreSQL password
BACKUP_DIR="./"                 # Backup directory (current directory)
BACKUP_NAME="backup_$(date +%Y%m%d_%H%M%S).dump"  # Timestamped backup name

# Export the password to the environment
export PGPASSWORD="$PG_PASSWORD"

# Run pg_dump
pg_dump -U "$PG_USER" -h "$PG_HOST" -d "$PG_DB" -F c -f "$BACKUP_DIR/$BACKUP_NAME"

# Check if the backup was successful
if [ $? -eq 0 ]; then
  echo "Backup successful! File saved to: $BACKUP_DIR$BACKUP_NAME"
else
  echo "Backup failed!"
  exit 1
fi

# Unset the password for security
unset PGPASSWORD
