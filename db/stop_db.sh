#!/bin/bash


CONTAINER_ID=$(docker ps | grep postgres | awk '{ print $1 }');
echo "CONTAINER_ID is : ${CONTAINER_ID}"

if [ ! -z ${CONTAINER_ID} ]; then
	echo "docker stop ${CONTAINER_ID} && docker rm ${CONTAINER_ID}"
	docker stop ${CONTAINER_ID} && docker rm ${CONTAINER_ID}
else
	echo "No DB container to stop"
fi
