# Stage 1: Build stage
FROM node:20-alpine AS build
WORKDIR /app

# Copy package files first (for caching dependencies)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of your project files
COPY . .

# Build the Vite project
RUN npm run build

# Stage 2: Nginx for serving production build
FROM nginx:alpine

# Copy built files from /app/dist to nginx html directory
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 for HTTP
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
