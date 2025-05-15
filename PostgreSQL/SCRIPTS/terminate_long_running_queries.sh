#!/usr/bin/bash

main() {

    local pg_schema="${1:-${PG_SCHEMA}}"
    local pg_db="${2:-${PG_DB}}"
    local pg_user="${3:-${PG_USER}}"
    local pg_host="${4:-${PG_HOST}}"

    local results=$( echo "select pid, now() - pg_stat_activity.query_start AS duration, query, state, pg_terminate_backend(pid) FROM pg_stat_activity WHERE (now() - pg_stat_activity.query_start) > interval '5 minutes' and state = 'active' and usename not in ('cqs_rds_naster_user','rdsadmin','rds_superuser','rds_replication');" | psql -d "${pg_db}" -U "${pg_user}" -h "${pg_host}" )

    echo $results;

}

if [ ! -z "$1" ] && [ ! -z "$2" ] && [ ! -z "$3" ] && [ ! -z "$4" ]
then
	PG_USER=$1
	PG_HOST=$2
	PG_SCHEMA=$3
	PG_DB=$4

	#vacuum_analyze_schema '<your-pg-schema>' '<your-pg-db>' '<your-pg-user>' '<your-pg-host>'
	main

else

	echo vacuum_analyze_schema '<your-pg-user>' '<your-pg-host>' '<your-pg-schema>' '<your-pg-db>'

fi
