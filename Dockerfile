# Use an official Node.js image as the base
FROM node:18

# Set working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json files
COPY package*.json ./

# Install dependencies
RUN npm install

# Install PostgreSQL
RUN apt-get update && \
    apt-get install -y postgresql postgresql-contrib

# Set up PostgreSQL environment variables (without password)
ENV POSTGRES_USER=postgres
ENV POSTGRES_DB=demo_db

# Copy the rest of the application files
COPY . .

# Expose ports for the Express app and PostgreSQL
EXPOSE 3000 5432

# Start PostgreSQL and initialize the database using a shell script
COPY init-db.sh /docker-entrypoint-initdb.d/init-db.sh
RUN chmod +x /docker-entrypoint-initdb.d/init-db.sh

# Start PostgreSQL and the Node.js server
CMD service postgresql start && tail -f /dev/null & node app.js
