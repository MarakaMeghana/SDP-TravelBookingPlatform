# Stage 1: Build
FROM node:20-alpine AS build
WORKDIR /app

# Copy portal package.json
COPY ./portal/package*.json ./

# Install dependencies for portal
RUN npm install --legacy-peer-deps

# Copy the rest of the portal app
COPY ./portal .

# Build the Vite project
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
