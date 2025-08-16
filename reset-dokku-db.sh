#!/bin/sh

# reset-dokku-db.sh
#
# This script resets the Dokku database by dropping all tables
#
# To use it:
# 1. login to the Dokku server
# 2. Identify the datbase name (`dokku postgres:list`)
# 3. Run this script with the database name as an argument


if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <database-name>"
    exit 1
fi

DATABASE_NAME=$1

# Check if the database exists
if ! dokku postgres:info "$DATABASE_NAME" > /dev/null 2>&1
then
    echo "Database '$DATABASE_NAME' does not exist."
    exit 1
fi  

# Drop all tables in the specified database
echo "DROP SCHEMA public CASCADE; CREATE SCHEMA public;" | dokku postgres:connect "$DATABASE_NAME" 

if [ $? -eq 0 ]; then
    echo "Successfully reset the database '$DATABASE_NAME'."
else
    echo "Failed to reset the database '$DATABASE_NAME'."
    exit 1
fi