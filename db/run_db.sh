#!/bin/bash

PWD=$(pwd)

echo "docker run --name postgresql -e POSTGRES_USER=wcsbot_dbuser -e POSTGRES_PASSWORD=xxx -p 5432:5432 -v ${PWD}:/var/lib/postgresql/data -d postgres"

docker run --name postgresql -e POSTGRES_USER=wcsbot_dbuser -e POSTGRES_PASSWORD=wcsbot_dbpass -p 5432:5432 -v ${PWD}/data:/var/lib/postgresql/data postgres

#docker run --name postgresql -e POSTGRES_USER=wcsbot_dbuser -e POSTGRES_PASSWORD=wcsbot_dbpass -p 5432:5432   postgres
