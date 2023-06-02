#!/bin/bash

echo "psql -h localhost -p 5432 -d wcsbot_repo -U test"
PGPASSWORD=wcsbot_dbpass psql -h localhost -p 5432 -d wcsbot_repo -U wcsbot_dbuser

