FROM java:8-jdk-alpine

ADD docker-example-0.1-SNAPSHOT.jar app.jar
ADD entrypoint.sh /

EXPOSE 8080

RUN chmod 750 /entrypoint.sh

ENTRYPOINT /entrypoint.sh
