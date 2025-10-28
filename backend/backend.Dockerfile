# ===== Stage 1: Build admin backend =====
FROM maven:3.9.4-eclipse-temurin-17 AS admin-build
WORKDIR /app/admin
COPY admin-backend/backend-admin/traveladmin/pom.xml .
RUN mvn dependency:go-offline -B
COPY admin-backend/backend-admin/traveladmin .
RUN mvn clean package -DskipTests

# ===== Stage 2: Build customer backend =====
FROM maven:3.9.4-eclipse-temurin-17 AS customer-build
WORKDIR /app/customer
COPY customer-backend/TravelBookingBackend/pom.xml .
RUN mvn dependency:go-offline -B
COPY customer-backend/TravelBookingBackend .
RUN mvn clean package -DskipTests

# ===== Stage 3: Create final combined image =====
FROM eclipse-temurin:17-jdk
WORKDIR /app

# Copy both JARs built from admin & customer
COPY --from=admin-build /app/admin/target/*.jar admin-backend.jar
COPY --from=customer-build /app/customer/target/*.jar customer-backend.jar

# Expose ports for both services (adjust if different)
EXPOSE 8081
EXPOSE 8082

# Optional: You can choose which service to run by passing an argument
CMD ["java", "-jar", "admin-backend.jar"]
