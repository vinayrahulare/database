/*
 * Retrieve a alist of partation that need be remove there is a limit size.
 * should probably secret up on it until there is on 14 days left.
 */
SELECT @plist := GROUP_CONCAT(PARTITION_NAME)
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_NAME='change_data_capture_logs' AND 
      TABLE_SCHEMA='member_master' AND
      REPLACE(PARTITION_DESCRIPTION,"'","") <= ( now() - INTERVAL 14 DAY) AND
      REPLACE(PARTITION_DESCRIPTION,"'","") != 'MAXVALUE';
	

     
SET @s = CONCAT('ALTER TABLE change_data_capture_logs DROP PARTITION ', @plist);

PREPARE stmt1 FROM @s;

EXECUTE stmt1;

DEALLOCATE PREPARE stmt1;

SELECT @plist;

/*
 * Left to do add and replacement partition. 
 */ 