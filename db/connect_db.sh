#!/bin/bash

echo "psql -h localhost -p 5432 -d wcsbot_repo -U test"
PGPASSWORD=passtest psql -h localhost -p 5432 -d wcsbot_repo -U test

