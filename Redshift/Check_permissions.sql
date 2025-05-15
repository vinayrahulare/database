/*List all users*/
select * from pg_user
order by usename asc;

/*Find users in a certain user group*/
SELECT groname, grosysid, usename, usesysid, usecreatedb, usesuper, usecatupd, passwd, valuntil, useconfig
FROM "admin".v_get_users_in_group
where groname = 'data_science_edw';

/*Find what user group a user connects to*/
SELECT groname, grosysid, usename, usesysid, usecreatedb, usesuper, usecatupd, passwd, valuntil, useconfig
FROM "admin".v_get_users_in_group
where usename in ('ewang');

/*Check what permissions a user has on a specific table*/
SELECT schemaname, "object", groupname, sel, upd, ins, del, drp, "ref"
FROM "admin".v_get_tbl_priv_by_group
where "object" = 'user_sessions';

/*Check what permissions a user has on a specific schema*/
SELECT distinct schemaname, groupname, sel, upd, ins, del, drp, "ref"
FROM "admin".v_get_tbl_priv_by_group
where groupname in (SELECT groname
FROM "admin".v_get_users_in_group
where usename in ('cj.estores','weisi.liao'));

/*List the user groups*/
select * from pg_group;

/*List the schema permissions for each user group*/
SELECT distinct schemaname, groupname, sel, upd, ins, del, drp, "ref"
FROM "admin".v_get_tbl_priv_by_group
where groupname = 'data_ops';

/*Check active permissions for a certain user*/
SELECT distinct a1.schemaname, a1.groupname,a2.usename, a1.sel, a1.upd, a1.ins, a1.del, a1.drp, a1."ref"
FROM "admin".v_get_tbl_priv_by_group a1
inner join "admin".v_get_users_in_group a2 
on a2.groname = a1.groupname 
and a2.usename = '<username>';

/*show all privs for a user on a specific schema*/
SELECT *
FROM
    (
    SELECT
        schemaname
        ,objectname
        ,usename
        ,HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'select') AND has_schema_privilege(usrs.usename, schemaname, 'usage')  AS sel
        ,HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'insert') AND has_schema_privilege(usrs.usename, schemaname, 'usage')  AS ins
        ,HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'update') AND has_schema_privilege(usrs.usename, schemaname, 'usage')  AS upd
        ,HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'delete') AND has_schema_privilege(usrs.usename, schemaname, 'usage')  AS del
        ,HAS_TABLE_PRIVILEGE(usrs.usename, fullobj, 'references') AND has_schema_privilege(usrs.usename, schemaname, 'usage')  AS ref
    FROM
        (
        SELECT schemaname, 't' AS obj_type, tablename AS objectname, schemaname + '.' + tablename AS fullobj FROM pg_tables
        WHERE schemaname NOT IN ('pg_internal')
        UNION
        SELECT schemaname, 'v' AS obj_type, viewname AS objectname, schemaname + '.' + viewname AS fullobj FROM pg_views
        WHERE schemaname NOT IN ('pg_internal')
        ) AS objs
        ,(SELECT * FROM pg_user) AS usrs
    ORDER BY fullobj
    )
WHERE (sel = TRUE OR ins = TRUE OR upd = TRUE OR del = TRUE OR ref = TRUE)
    and usename = 'user_name'
    and schemaname = 'data_science_edw_staging';

/*show all privs for role*/
SELECT
    u.usename,
    s.schemaname,
    has_schema_privilege(u.usename,s.schemaname,'create') AS user_has_select_permission,
    has_schema_privilege(u.usename,s.schemaname,'usage') AS user_has_usage_permission
FROM
    pg_user u
CROSS JOIN
    (SELECT DISTINCT schemaname FROM pg_tables) s
WHERE
    u.usename = 'job_analyst'
    AND s.schemaname = 'marketo'
;

/*List Redshift tables, views and their owners*/
SELECT n.nspname AS schema_name
 , pg_get_userbyid(c.relowner) AS table_owner
 , c.relname AS table_name
 , CASE WHEN c.relkind = 'v' THEN 'view' ELSE 'table' END
   AS table_type
 FROM pg_class As c
 LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
 LEFT JOIN pg_tablespace t ON t.oid = c.reltablespace
 LEFT JOIN pg_description As d 
      ON (d.objoid = c.oid AND d.objsubid = 0)
 WHERE c.relkind IN('r', 'v') 
 and n.nspname = 'marketing_th_core'
ORDER BY n.nspname, c.relname ;

/*Table creation DATE*/
SELECT
TRIM(nspname) AS schema_name,
TRIM(relname) AS table_name,
relcreationtime AS creation_time
FROM pg_class_info
LEFT JOIN pg_namespace ON pg_class_info.relnamespace = pg_namespace.oid
WHERE reltype != 0
AND TRIM(nspname) = 'schemanamehere'
and TRIM(relname) = 'tablenamehere';

/*REVOKE GRANT Privileges for users/GROUPS*/
REVOKE GRANT OPTION FOR ALL PRIVILEGES ON ALL TABLES IN SCHEMA <schemaname> FROM <username>;
REVOKE GRANT OPTION FOR ALL PRIVILEGES ON SCHEMA <schemaname> FROM <username>;
REVOKE GRANT OPTION FOR ALL PRIVILEGES ON DATABASE <dbname> FROM <username>;