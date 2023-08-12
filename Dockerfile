# Stage 1: Clone the source code
FROM alpine/git AS vcs
RUN cd / && git clone https://github.com/wakaleo/game-of-life.git

# Stage 2: Build the application
FROM maven:3-amazoncorretto-8 AS builder
COPY --from=vcs /game-of-life /game-of-life
RUN cd /game-of-life && mvn package

# Stage 3: Create the final image
FROM tomcat:9-jdk8
LABEL author="shoaib" organization="qt"

# Copy the built application from the previous stage
COPY --from=builder /game-of-life/gameoflife-web/target/*.war /usr/local/tomcat/webapps/gameoflife.war

# Expose the port
EXPOSE 8080