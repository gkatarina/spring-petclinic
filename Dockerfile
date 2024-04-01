# 1. task: create dockerfile for for spring petclinic using pre-built artifact 
# FROM openjdk
# EXPOSE 8080
# COPY spring-petclinic-3.2.0-SNAPSHOT.jar spring-petclinic-3.2.0-SNAPSHOT.jar
# CMD ["java","-jar","spring-petclinic-3.2.0-SNAPSHOT.jar"]

# in terminal:  
# 1) build the image: docker build -t imageName . 
# 2) run the image: docker run -p 8080:8080 imageName 

# 2. task: create multi-stage dockerfile for petclinic app

# app should be built as part of the first stage
# final image should contain only required files and based on minimal possible
# base image

# FROM maven:latest as build
# COPY . /spring-petclinic
# CMD ["./mvnw", "package"]

# FROM openjdk
# EXPOSE 8080
# COPY --from=build /spring-petclinic/target/spring-petclinic-3.2.0-SNAPSHOT.jar .
# CMD ["java","-jar","spring-petclinic-3.2.0-SNAPSHOT.jar"]

# 3rd task 
#  sudo docker compose up to run mysql and petclinic app
FROM maven:latest as build
COPY . /spring-petclinic
CMD ["./mvnw", "package"]

FROM eclipse-temurin:17-jdk-jammy as development
EXPOSE 8080
COPY --from=build /spring-petclinic/target/spring-petclinic-3.2.0-SNAPSHOT.jar .
CMD ["java","-jar","spring-petclinic-3.2.0-SNAPSHOT.jar"]

