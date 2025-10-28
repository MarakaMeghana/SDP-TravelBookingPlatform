# ========================
# Stage 1: Build the React app
# ========================
FROM node:20-alpine AS build

# Add build dependencies (important for alpine)
RUN apk add --no-cache python3 make g++ bash

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install --legacy-peer-deps

# Copy rest of the frontend source
COPY . .

# Build production files
RUN npm run build

# ========================
# Stage 2: Serve with Nginx
# ========================
FROM nginx:alpine

# Copy built files from previous stage
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
