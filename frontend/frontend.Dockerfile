# Stage 1: Build
FROM node:20 AS build
WORKDIR /app

COPY package*.json ./

# Add verbose logging for debugging
RUN npm config set loglevel verbose

# Try installation, but print logs if it fails
RUN npm install --legacy-peer-deps || cat /root/.npm/_logs/*

COPY . .

# Try building, but print logs if it fails
RUN npm run build || cat /root/.npm/_logs/*

# Stage 2: Serve production
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
