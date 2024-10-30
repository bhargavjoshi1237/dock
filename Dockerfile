# Stage 1: Prepare Application Code
FROM node:14 as builder

# Set working directory to /app
WORKDIR /app

# Install dependencies (assuming package*.json is already present)
RUN npm install

# Stage 2: Setup PostgreSQL and Express.js Runtime
FROM ubuntu:20.04

WORKDIR /app
ENV POSTGRES_USER=myuser
ENV POSTGRES_PASSWORD=mypassword
ENV POSTGRES_DB=mydb
ENV DATABASE_HOST=localhost
ENV DATABASE_PORT=5432
ENV NODE_ENV=production

# Install PostgreSQL and Node.js
RUN apt-get update && apt-get install -y postgresql-13 postgresql-client-13 nodejs npm
RUN service postgresql start

# Create PostgreSQL user and database for the app
RUN sudo -u postgres psql -c "CREATE USER myuser WITH PASSWORD 'ypassword';"
RUN sudo -u postgres psql -c "CREATE DATABASE mydb OWNER myuser;"

# Copy only the necessary application code from the builder stage
COPY --from=builder /app/app.js /app/
COPY --from=builder /app/package*.json /app/

# Reinstall dependencies (since we're in a new stage)
RUN npm install

# Expose the port
EXPOSE 3000

# Run command to initialize database with demo data and then start the Express.js app
CMD ["sh", "-c", "
  # Wait for PostgreSQL to be available
  while! nc -z $DATABASE_HOST $DATABASE_PORT; do sleep 0.1; done;

  # Initialize database with demo data
  psql -U $POSTGRES_USER -d $POSTGRES_DB -h $DATABASE_HOST -c \"CREATE TABLE IF NOT EXISTS demo (id SERIAL PRIMARY KEY, name VARCHAR(255));\";
  psql -U $POSTGRES_USER -d $POSTGRES_DB -h $DATABASE_HOST -c \"INSERT INTO demo (name) VALUES ('Demo User 1'), ('Demo User 2');\";

  # Start the Express.js application
  node app.js
"]