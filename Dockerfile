## Stage 1: Build the application
#FROM maven:3.8.4-openjdk-17 AS build
#WORKDIR /app
#COPY pom.xml .
#COPY src ./src
#RUN mvn clean install
#
## Stage 2: Run the application
#FROM openjdk:17-alpine
#WORKDIR /app
#COPY --from=build /app/target/aws-0.0.1-SNAPSHOT.jar ./demo-aws.jar
#EXPOSE 8080
#CMD ["java", "-jar", "demo-aws.jar"]

# Stage 1: Build the application
FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app

# Copy only pom.xml to leverage Docker cache for dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build the application and skip tests for faster build
RUN mvn clean install -DskipTests

# Stage 2: Run the application
FROM openjdk:17-alpine
WORKDIR /app

# Copy the built jar from build stage
COPY --from=build /app/target/aws-0.0.1-SNAPSHOT.jar ./demo-aws.jar

EXPOSE 8080
CMD ["java", "-jar", "demo-aws.jar"]