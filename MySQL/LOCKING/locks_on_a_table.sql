USE INFORMATION_SCHEMA;
SELECT * FROM INNODB_LOCKS 
WHERE LOCK_TABLE = db_name.table_name;
