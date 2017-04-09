#!/bin/bash

containerId=`cat /proc/self/cgroup | grep -o  -e "docker-.*.scope" | head -n 1 | sed "s/docker-\(.*\).scope/\\1/"`
if [ -z "$containerId" ]; then echo "Try second way to find containerId"; containerId=$(cat /proc/self/cgroup | grep "docker" | sed s/\\//\\n/g | tail -1); fi

echo "containerId: " $containerId
shortContainerId=`echo $containerId | cut -c 1-12`
echo "shortContainerId: " $shortContainerId

export CONTAINER_ID=$shortContainerId
[[ ! -f /ip.txt ]] || export `cat /ip.txt`

echo "=========env"
set

if [ -z "$JVM_MEMORY_OPTS" ]; then JVM_MEMORY_OPTS="-Xss256k -Xms255m -Xmx1g"; echo "JVM_MEMORY_OPTS is not set. Use default: $JVM_MEMORY_OPTS"; fi
if [ -z "$DOCKER_HOST" ]; then echo "DOCKER_HOST is UNKNOWN"; DOCKER_HOST="UNKNOWN"; fi
if [ -z "$APPNAME" ]; then echo "APPNAME is UNKNOWN"; APPNAME="UNKNOWN"; fi
if [ -z "$ENV" ]; then echo "ENV is UNKNOWN"; ENV="UNKNOWN"; fi
if [ -z "$CONTAINER_ID" ]; then echo "CONTAINER_ID is UNKNOWN"; CONTAINER_ID="UNKNOWN"; fi

java \
    $JVM_MEMORY_OPTS \
    -Djava.security.egd=file:/dev/./urandom \
    -Ddocker_host=$DOCKER_HOST \
    -Dappname=$APPNAME \
    -Denv=$ENV \
    -Dcontainer_id=$CONTAINER_ID \
    -jar /app.jar
