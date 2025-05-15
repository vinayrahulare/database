#!/usr/bin/bash
#
# 
# requirements mysql-client and .my.cnf
# 
# .my.cnf content
# [client]
# user=admin_user
# password=admin_password
#
MYSQL=/usr/bin/mysql

extract_grants(){

$MYSQL --host=$MYSQL_HOST --port=$MYSQL_PORT -N -B \
-e "SELECT Concat('create user \'', user, '\'@\'', host, '\' IDENTIFIED WITH \'mysql_native_password\' AS \'', authentication_string,'\';') FROM mysql.user where user not in ('mysql.sys','mysql','root','rdsadmin');"

$MYSQL --host=$MYSQL_HOST --port=$MYSQL_PORT -N -B \
-e "SELECT CONCAT('SHOW GRANTS FOR ''',user,'''@''',host,''';') FROM mysql.user where user not in ('mysql.sys','mysql','root','rdsadmin');" | $MYSQL --host=$MYSQL_HOST --port=$MYSQL_PORT -N -B | sed 's/$/;/g'

}

if [ ! -z "$1" ] && [ ! -z "$2" ]
then

        MYSQL_HOST=$1
        MYSQL_PORT=$2

        extract_grants
        
else

   echo  '<MYSQL_HOST>' '<MYSQL_PORT>'

fi
