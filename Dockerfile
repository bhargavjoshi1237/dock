# Use an official Node.js image as the base
FROM node:18

# Set working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json files
COPY package*.json ./

# Install Express.js
RUN npm install

# Install PostgreSQL
RUN apt-get update && \
    apt-get install -y postgresql postgresql-contrib

# Copy the rest of the application files
COPY . .

# Set up the PostgreSQL environment variables
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=password
ENV POSTGRES_DB=demo_db

# Initialize the database and seed data
RUN service postgresql start && \
    su - postgres -c "psql -c \"CREATE DATABASE ${POSTGRES_DB};\"" && \
    su - postgres -c "psql -d ${POSTGRES_DB} -f /app/init.sql"

# Expose port 3000 for the Express app and 5432 for PostgreSQL
EXPOSE 3000 5432

# Start both PostgreSQL and the Node.js server
CMD service postgresql start && node app.js
