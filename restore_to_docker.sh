#!/bin/bash

# Set variables
CONTAINER_NAME="postgres_container" # Name of the PostgreSQL Docker container
POSTGRES_IMAGE="postgres:latest"   # PostgreSQL Docker image
DB_NAME="your_database"            # Database name to restore into
DB_USER="your_username"            # PostgreSQL username
DB_PASSWORD="your_password"        # PostgreSQL password
DUMP_FILE="your_dump_file.dump"    # Path to the dump file
DB_PORT="5432"                     # Port to expose PostgreSQL

# Check if the Docker container already exists
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
  echo "PostgreSQL Docker container '$CONTAINER_NAME' already exists."
else
  echo "Creating PostgreSQL Docker container '$CONTAINER_NAME'..."
  docker run -d --name $CONTAINER_NAME \
    -e POSTGRES_USER=$DB_USER \
    -e POSTGRES_PASSWORD=$DB_PASSWORD \
    -e POSTGRES_DB=$DB_NAME \
    -p $DB_PORT:5432 \
    $POSTGRES_IMAGE
  
  # Wait for PostgreSQL to initialize
  echo "Waiting for PostgreSQL to initialize..."
  sleep 10
fi

# Export the password to the environment
export PGPASSWORD=$DB_PASSWORD

# Restore the database
echo "Restoring the database from '$DUMP_FILE'..."
docker exec -i $CONTAINER_NAME pg_restore -U $DB_USER -d $DB_NAME --clean --no-owner < $DUMP_FILE

# Check if the restore was successful
if [ $? -eq 0 ]; then
  echo "Restore successful! Data restored into database: $DB_NAME"
else
  echo "Restore failed!"
  exit 1
fi

# Unset the password for security
unset PGPASSWORD
