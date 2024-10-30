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

# Run database setup and seed data
RUN service postgresql start && \
    su - postgres -c "psql -f /app/init.sql"

# Expose port 3000
EXPOSE 3000

# Start the Express application
CMD ["node", "app.js"]
