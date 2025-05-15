/*
SELECT
      u.usename,
	  s.schemaname,
	  s.tablename,
    case 
    	when has_schema_privilege(u.usename,s.schemaname,'create') or has_table_privilege(u.usename,s.schemaname||'.'||s.tablename,'insert') or has_table_privilege(u.usename,s.schemaname||'.'||s.tablename,'update') or has_table_privilege(u.usename,s.schemaname||'.'||s.tablename,'delete') then 'Read/Write'
    	when has_schema_privilege(u.usename,s.schemaname,'usage') or has_table_privilege(u.usename,s.schemaname||'.'||s.tablename,'select') or has_table_privilege(u.usename,s.schemaname||'.'||s.tablename,'references') then 'Read'
    	else 'Read'
    end as p
FROM
    pg_user u
CROSS JOIN
    (SELECT DISTINCT schemaname, tablename FROM pg_tables
     where schemaname in (
     'anthem', 'billing_snapshots', 'data_ops', 'data_science_edw', 'data_science_edw_staging', 'data_sciences', 'dengberg', 'equalizer_spark_test', 'etl', 'external_imports', 
     'external_pii', 'marketing', 'marketing_ndp', 'marketing_th_core','medispan', 'mystrength', 'nonpii', 'personalization', 'pii', 'provider_payments', 'public', 'retrofit_raw', 'staging', 'tracking')
     ) s
where u.valuntil isnull;


SELECT * FROM pg_user WHERE valuntil isnull;
*/

SELECT
      u.usename user_name,
      u.usesuper super_user,
	  s.schemaname schema_name,
	  s.tablename table_name,
      has_schema_privilege(u.usename,s.schemaname,'create') has_create,
      has_table_privilege(u.usename,s.schemaname||'.'||s.tablename,'insert') has_insert,
      has_table_privilege(u.usename,s.schemaname||'.'||s.tablename,'update') has_update,
      has_table_privilege(u.usename,s.schemaname||'.'||s.tablename,'delete') has_delete,
      has_table_privilege(u.usename,s.schemaname||'.'||s.tablename,'select') has_select,
      has_table_privilege(u.usename,s.schemaname||'.'||s.tablename,'references') has_references
FROM
    pg_user u
CROSS JOIN
    (SELECT DISTINCT schemaname, tablename FROM pg_tables where schemaname not like 'pg_%' and schemaname not like 'data_science_edw_staging%')s
where u.valuntil isnull and (super_user = 1 or has_create = 1 or has_insert = 1 or has_update = 1 or has_delete = 1 or has_select = 1 or has_references = 1 ) AND u.usename = "Michael.Chen"
order by user_name;


/*select user_name, schema_name, super_user, has_create, has_insert, has_update, has_delete, has_select, has_references
from (
	select u.usename user_name, u.usesuper super_user, s.schemaname schema_name, has_schema_privilege(u.usename,s.schemaname,'create') has_create,
          has_table_privilege(u.usename,s.schemaname||'.'||s.tablename,'insert') has_insert, has_table_privilege(u.usename,s.schemaname||'.'||s.tablename,'update') has_update,
          has_table_privilege(u.usename,s.schemaname||'.'||s.tablename,'delete') has_delete, has_table_privilege(u.usename,s.schemaname||'.'||s.tablename,'select') has_select,
          has_table_privilege(u.usename,s.schemaname||'.'||s.tablename,'references') has_references
    from pg_user u
    CROSS join ( SELECT DISTINCT schemaname, tablename FROM pg_tables where schemaname not like 'pg_%')s
    where u.usename in ('neel.tangella','arash.khalilnejad') and (super_user = 1 or has_create = 1 or has_insert = 1 or has_update = 1 or has_delete = 1 or has_select = 1 or has_references = 1 ) )
group by user_name, schema_name, super_user, has_create, has_insert, has_update, has_delete, has_select, has_references
order by user_name, schema_name, has_select, has_create, has_insert, has_update, has_delete;
*/

/* Script to audit user privileges */
select user_name, schema_name, super_user, has_create, has_insert, has_update, has_delete, has_select, has_references, valuntil
from (
	select u.usename user_name, u.usesuper super_user, s.schemaname schema_name, has_schema_privilege(u.usename,s.schemaname,'create') has_create,
          has_table_privilege(u.usename,s.schemaname||'.'||s.tablename,'insert') has_insert, has_table_privilege(u.usename,s.schemaname||'.'||s.tablename,'update') has_update,
          has_table_privilege(u.usename,s.schemaname||'.'||s.tablename,'delete') has_delete, has_table_privilege(u.usename,s.schemaname||'.'||s.tablename,'select') has_select,
          has_table_privilege(u.usename,s.schemaname||'.'||s.tablename,'references') has_references,
          valuntil
    from pg_user u
    CROSS join ( SELECT DISTINCT schemaname, tablename FROM pg_tables 
    where schemaname not like 'pg_%' and tablename not like '%newsletter_exp_prior_lookback_temptable%' ) s 
    where  (super_user = 1 or has_create = 1 or has_insert = 1 or has_update = 1 or has_delete = 1 or has_select = 1 or has_references = 1 ) and (u.valuntil > NOW() or u.valuntil is NULL) 
    )
group by user_name, schema_name, super_user, has_create, has_insert, has_update, has_delete, has_select, has_references, valuntil
order by user_name, schema_name, has_select, has_create, has_insert, has_update, has_delete;

-- https://docs.aws.amazon.com/redshift/latest/dg/r_Groups.html
SELECT u.usesysid
,g.groname
,u.usename
FROM pg_user u
LEFT JOIN pg_group g ON u.usesysid = ANY (g.grolist)
WHERE u.usename in ( 'julia.camina',
'pedro.perenzin',
'marcus.silva',
'adarsh.tomar',
'aleix.solanes',
'atefeh.hezavehei',
'ekaterina.kotina',
'eugenia.bezek',
'filippo.rocchetta',
'luciana.montivero',
'marta.fedyshyn',
'michal.korzen',
'pablo.noras',
'riccardo.stocco',
'rui.diogo',
'valldeflors.ribalta');

-- Viewing grants;
-- https://docs.aws.amazon.com/redshift/latest/dg/r_SHOW_GRANTS.html
-- https://docs.aws.amazon.com/redshift/latest/dg/r_SVV_SCHEMA_PRIVILEGES.html
SHOW GRANTS FOR dbadmin;

SHOW GRANTS FOR vare; 

SHOW GRANTS ON SCHEMA data_ops FOR ROLE PUBLIC;

SHOW GRANTS FOR ROLE data_sciences;

SHOW GRANTS ON SCHEMA data_ops FOR 'valldeflors.ribalta'; 

SHOW GRANTS ON TABLE data_sciences.backoffice_email_delivery_framework_20230701;

SELECT namespace_name,privilege_type,identity_name,identity_type,admin_option FROM svv_schema_privileges WHERE namespace_name = 'data_sciences';

-- SELECT * FROM pg_user where usename = 'claims_billing';












































