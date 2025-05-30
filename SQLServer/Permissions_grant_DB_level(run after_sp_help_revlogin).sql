--Role Memberships'

SELECT	 --rm.role_principal_id,
'EXEC sp_addrolemember @rolename =' 
+ SPACE(1) + QUOTENAME(USER_NAME(rm.role_principal_id), '''') 
+ ', @membername =' + SPACE(1) + QUOTENAME(USER_NAME(rm.member_principal_id), '''') AS '--Role Memberships'
FROM	sys.database_role_members AS rm
ORDER BY rm.role_principal_id 


--Object Level Permissions'
SELECT	
CASE WHEN perm.state != 'W' THEN perm.state_desc ELSE 'GRANT' END + SPACE(1) + 
perm.permission_name + SPACE(1) + 'ON '+ QUOTENAME(Schema_NAME(obj.schema_id)) + '.' 
+ QUOTENAME(obj.name) collate Latin1_General_CI_AS_KS_WS	
+ CASE WHEN cl.column_id IS NULL THEN SPACE(0) ELSE '(' + QUOTENAME(cl.name) + ')' END
+ SPACE(1) + 'TO' + SPACE(1) + QUOTENAME(usr.name)
+ CASE WHEN perm.state <> 'W' THEN SPACE(0) ELSE SPACE(1) + 'WITH GRANT OPTION' END AS '--Object Level Permissions'
FROM	sys.database_permissions AS perm
INNER JOIN
sys.objects AS obj
ON perm.major_id = obj.[object_id]
INNER JOIN
sys.database_principals AS usr
ON perm.grantee_principal_id = usr.principal_id
LEFT JOIN
sys.columns AS cl
ON cl.column_id = perm.minor_id AND cl.[object_id] = perm.major_id
ORDER BY usr.name

--Database Level Permissions'
SELECT	CASE WHEN perm.state <> 'W' THEN perm.state_desc ELSE 'GRANT' END
+ SPACE(1) + perm.permission_name + SPACE(1)
+ SPACE(1) + 'TO' + SPACE(1) + QUOTENAME(usr.name) COLLATE database_default
+ CASE WHEN perm.state <> 'W' THEN SPACE(0) ELSE SPACE(1) + 'WITH GRANT OPTION' END AS '--Database Level Permissions'
FROM	sys.database_permissions AS perm
INNER JOIN
sys.database_principals AS usr
ON perm.grantee_principal_id = usr.principal_id
WHERE	
--usr.name = @OldUser
--AND	
perm.major_id = 0
ORDER BY perm.permission_name ASC, perm.state_desc ASC