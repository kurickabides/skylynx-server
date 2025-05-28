# Base image
FROM node:18

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the port Express.js runs on
EXPOSE 3200

# Start the server
CMD ["npm", "start"]
