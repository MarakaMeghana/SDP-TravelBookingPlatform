# ---------- Stage 1: Build ----------
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy all backend source files
COPY . .

# Build both backend JARs (skip tests)
RUN mvn -f admin-backend/backend-admin/traveladmin/pom.xml clean package -DskipTests
RUN mvn -f customer-backend/TravelBookingBackend/pom.xml clean package -DskipTests

# ---------- Stage 2: Run ----------
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

# Copy built JARs from the builder
COPY --from=builder /app/admin-backend/backend-admin/traveladmin/target/*.jar /app/admin.jar
COPY --from=builder /app/customer-backend/TravelBookingBackend/target/*.jar /app/customer.jar

# Default command (can override per service)
CMD ["java", "-jar", "/app/customer.jar"]
