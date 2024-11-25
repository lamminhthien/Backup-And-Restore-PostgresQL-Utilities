#!/bin/bash

# Set variables
PG_USER="your_username"         # PostgreSQL username
PG_HOST="your_host"             # PostgreSQL host (e.g., localhost or IP)
PG_DB="your_database"           # Database name to restore into
PG_PASSWORD="your_password"     # PostgreSQL password
DUMP_FILE="your_dump_file.dump" # Path to the dump file

# Export the password to the environment
export PGPASSWORD="$PG_PASSWORD"

# Restore the database
pg_restore -U "$PG_USER" -h "$PG_HOST" -d "$PG_DB" --clean --no-owner "$DUMP_FILE"

# Check if the restore was successful
if [ $? -eq 0 ]; then
  echo "Restore successful! Data restored into database: $PG_DB"
else
  echo "Restore failed!"
  exit 1
fi

# Unset the password for security
unset PGPASSWORD
