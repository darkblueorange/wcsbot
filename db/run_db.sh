#!/bin/bash

echo "docker run --name postgresql -e POSTGRES_USER=test -e POSTGRES_PASSWORD=xxx -p 5432:5432 -v /Users/olivierdeprez/Library/CloudStorage/OneDrive-Personnel/Boulot/7lieues/PRODUCT/Technical_stuff/Code/sources/test/db:/var/lib/postgresql/data -d postgres"
docker run --name postgresql -e POSTGRES_USER=test -e POSTGRES_PASSWORD=passtest -p 5432:5432 -v /Users/olivierdeprez/Library/CloudStorage/OneDrive-Personnel/Boulot/7lieues/PRODUCT/Technical_stuff/Code/sources/test/db:/var/lib/postgresql/data -d postgres

