#!/bin/bash

# Wait for PostgreSQL to start
sleep 5

# Create the demo_db database
psql -U postgres -c "CREATE DATABASE demo_db;"
