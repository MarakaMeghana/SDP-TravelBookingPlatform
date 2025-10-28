# =========================
# Stage 1: Build Backend JARs
# =========================
FROM maven:3.9.4-eclipse-temurin-17 AS build
WORKDIR /app

# Copy both backend modules into the container
COPY admin-backend/backend-admin/traveladmin ./admin-backend/backend-admin/traveladmin
COPY customer-backend/TravelBookingBackend ./customer-backend/TravelBookingBackend

# Build both projects
RUN mvn -f admin-backend/backend-admin/traveladmin/pom.xml clean package -DskipTests
RUN mvn -f customer-backend/TravelBookingBackend/pom.xml clean package -DskipTests

# =========================
# Stage 2: Run the backend
# =========================
FROM eclipse-temurin:17-jdk
WORKDIR /app

# Copy both built JARs
COPY --from=build /app/admin-backend/backend-admin/traveladmin/target/*.jar /app/admin-backend.jar
COPY --from=build /app/customer-backend/TravelBookingBackend/target/*.jar /app/customer-backend.jar

# Expose ports for both backend services
EXPOSE 8080
EXPOSE 8081

# Run both JARs (using background + foreground pattern)
CMD java -jar /app/admin-backend.jar & java -jar /app/customer-backend.jar
