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

# Set up PostgreSQL environment variables
ENV POSTGRES_USER=postgres
ENV POSTGRES_DB=demo_db

# Copy the rest of the application files
COPY . .

# Expose port 3000 for the Express app and 5432 for PostgreSQL
EXPOSE 3000 5432

# Start PostgreSQL without password authentication and initialize the database
RUN echo "local all all trust" > /etc/postgresql/12/main/pg_hba.conf && \
    service postgresql start && \
    psql --username=$POSTGRES_USER -c "CREATE DATABASE $POSTGRES_DB;"

# Start PostgreSQL and the Node.js server
CMD service postgresql start && node app.js
