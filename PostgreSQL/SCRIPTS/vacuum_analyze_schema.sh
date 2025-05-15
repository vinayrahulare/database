#!/usr/bin/bash

vacuum_analyze_schema() {
    # vacuum analyze only the tables in the specified schema

    # postgres info can be supplied by either passing it as parameters to this
    # function, setting environment variables or a combination of the two
    local pg_schema="${1:-${PG_SCHEMA}}"
    local pg_db="${2:-${PG_DB}}"
    local pg_user="${3:-${PG_USER}}"
    local pg_host="${4:-${PG_HOST}}"

    echo "Vacuuming schema \`${pg_schema}\`:"

    # extract schema table names from psql output and put them in a bash array
    local psql_tbls="\dt ${pg_schema}.*"
    local sed_str="s/${pg_schema}\s+\|\s+(\w+)\s+\|.*/\1/p"
    local table_names=$( echo "${psql_tbls}" | psql -d "${pg_db}" -U "${pg_user}" -h "${pg_host}"  | sed -nr "${sed_str}" )
    local tables_array=( $( echo "${table_names}" | tr '\n' ' ' ) )

    # loop through the table names creating and executing a vacuum
    # command for each one
    for t in "${tables_array[@]}"; do
        echo `/usr/bin/date`" VACUUM ANALYZE table \`${t}\`..."
        psql -d "${pg_db}" -U "${pg_user}" -h "${pg_host}" \
            -c "VACUUM (ANALYZE) ${pg_schema}.${t};"
    done
}

if [ ! -z "$1" ] && [ ! -z "$2" ] && [ ! -z "$3" ] && [ ! -z "$4" ]
then
        PG_USER=$1
        PG_HOST=$2
        PG_SCHEMA=$3
        PG_DB=$4

        #vacuum_analyze_schema '<your-pg-schema>' '<your-pg-db>' '<your-pg-user>' '<your-pg-host>'
        vacuum_analyze_schema

else

   echo vacuum_analyze_schema '<your-pg-user>' '<your-pg-host>' '<your-pg-schema>' '<your-pg-db>'

fi
