# Stage 1: Build the Express.js Application
FROM node:14 as builder

# Set working directory to /app
WORKDIR /app

# Copy package*.json to install dependencies
COPY package*.json /app/

# Install dependencies
RUN npm install

# Copy the application code
COPY..

# Build the application (if your app needs a build step, adjust accordingly)
# For a simple Express.js app, this might not be necessary
# RUN npm run build

# Stage 2: Setup PostgreSQL and Express.js Runtime
FROM ubuntu:20.04

# Set working directory to /app
WORKDIR /app

# Install PostgreSQL
RUN apt-get update && apt-get install -y postgresql-13 postgresql-client-13
RUN service postgresql start

# Create PostgreSQL user and database for the app
RUN sudo -u postgres psql -c "CREATE USER myuser WITH PASSWORD 'ypassword';"
RUN sudo -u postgres psql -c "CREATE DATABASE mydb OWNER myuser;"

# Set environment variables
ENV POSTGRES_USER=myuser
ENV POSTGRES_PASSWORD=mypassword
ENV POSTGRES_DB=mydb
ENV DATABASE_HOST=localhost
ENV DATABASE_PORT=5432
ENV NODE_ENV=production

# Copy application code from the builder stage
COPY --from=builder /app.

# Expose the port
EXPOSE 3000

# Run command to initialize database with demo data and then start the Express.js app
CMD ["sh", "-c", "
    # Wait for PostgreSQL to be available
    while! nc -z $DATABASE_HOST $DATABASE_PORT; do sleep 0.1; done;
    
    # Initialize database with demo data
    psql -U $POSTGRES_USER -d $POSTGRES_DB -h $DATABASE_HOST -c \"CREATE TABLE IF NOT EXISTS demo (id SERIAL PRIMARY KEY, name VARCHAR(255));\";
    psql -U $POSTGRES_USER -d $POSTGRES_DB -h $DATABASE_HOST -c \"INSERT INTO demo (name) VALUES ('Demo User 1'), ('Demo User 2');\";
    
    # Install Node.js (since we switched to an Ubuntu base image)
    apt-get update && apt-get install -y nodejs npm
    
    # Start the Express.js application
    node app.js
"]