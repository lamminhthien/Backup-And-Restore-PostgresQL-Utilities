#!/bin/bash

# Set variables
REMOTE_HOST="remote_host_ip_or_domain"  # Remote PostgreSQL server host
REMOTE_PORT="5432"                     # PostgreSQL port (default is 5432)
DB_NAME="your_database"                # Database name to restore into
DB_USER="your_username"                # PostgreSQL username
DB_PASSWORD="your_password"            # PostgreSQL password
DUMP_FILE="your_dump_file.dump"        # Path to the dump file

# Export the password to the environment
export PGPASSWORD="$DB_PASSWORD"

# Restore the database
echo "Restoring the database to the remote server ($REMOTE_HOST)..."
pg_restore -h "$REMOTE_HOST" -p "$REMOTE_PORT" -U "$DB_USER" -d "$DB_NAME" --clean --no-owner "$DUMP_FILE"

# Check if the restore was successful
if [ $? -eq 0 ]; then
  echo "Restore successful! Data restored into database: $DB_NAME on $REMOTE_HOST"
else
  echo "Restore failed!"
  exit 1
fi

# Unset the password for security
unset PGPASSWORD
