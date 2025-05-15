# SQL Server Administration Tools

This directory contains a comprehensive collection of SQL Server administration scripts, tools, and documentation.

## Table of Contents
- [Performance Monitoring](#performance-monitoring)
- [Security Management](#security-management)
- [High Availability](#high-availability)
- [Backup and Recovery](#backup-and-recovery)
- [Database Maintenance](#database-maintenance)
- [PowerShell Scripts](#powershell-scripts)
- [DBA Utilities](#dba-utilities)

## Performance Monitoring

### Active Monitoring
- `who_is_active_v11_11.sql` - Comprehensive active session monitoring
- `Top_CPU_taxing_Queries.sql` - Identify CPU-intensive queries
- `SQL Performance - Script to triage wait stats.txt` - Wait statistics analysis
- `SQL Server Performance Triage.docx` - Performance troubleshooting guide

### Resource Monitoring
- `MemorySettingsAndCountersCode.txt` - Memory configuration and monitoring
- `How Much Plan Cache History Do You Have.txt` - Plan cache analysis
- `SQL_server_info.txt` - Server configuration information

## Security Management

### User and Permission Management
- `Audit Users permissions.txt` - User permission auditing
- `Permissions_grant_DB_level.sql` - Database-level permission management
- `Grant_view_permission_to_Activity_Monitor.sql` - Activity monitor access
- `Grant read access to all SPs, Tables, Functions & views.txt` - Read access management
- `permissions-of-database-roles.png` - Role permission reference

### Encryption and Security
- `TDE-View all encrypted DBs and their certs.txt` - TDE certificate management
- `Configure_TDE.sql` - Transparent Data Encryption setup
- `tde-architecture.gif` - TDE architecture diagram
- `XP_cmdshell and permissions.docx` - XP_cmdshell security configuration

## High Availability

### AlwaysOn Configuration
- `Setup AlwaysOn Cluster in SQL Server 2012.docx` - AlwaysOn setup guide
- `WindowsCluster_SQLAlwaysOn_Update_HostRecordTTL.ps1` - DNS TTL management
- `How to Avoid Orphan Users in SQL Server ALWAYSON.docx` - AlwaysOn user management

## Backup and Recovery

### Backup Management
- `Backup History.txt` - Backup history tracking
- `Moving A Database to New Storage With No Downtime.docx` - Storage migration guide
- `Fix Recovery Pending State in SQL server Database.docx` - Recovery state troubleshooting

### Database Recovery
- `Revive a database from SUSPECT mode.txt` - Suspect mode recovery
- `Steps to rename a SQL server database.docx` - Database renaming procedure

## Database Maintenance

### Index Management
- `Index Fragmentation - database level.txt` - Index fragmentation analysis
- `Find unused indexes.txt` - Unused index identification

### Space Management
- `Table Size with Row Counts.txt` - Table size analysis
- `SQL Server – How to Best Remove Extra TempDB Data Files and Log Files.docx` - TempDB management
- `SQL SERVER – TempDB is Full. Move TempDB from one drive to another drive..docx` - TempDB relocation

### User Management
- `Stored Proc to drop Orphaned users in a database.txt` - Orphaned user cleanup
- `Fix SQL Server orphaned users.docx` - Orphaned user resolution

## PowerShell Scripts

Located in the `powershell_scripts` directory:
- Various automation scripts for SQL Server management
- Windows integration tools
- Cluster management utilities

## DBA Utilities

Located in the `DBAUtility` directory:
- Database administration tools
- Maintenance utilities
- Monitoring solutions

## Usage Guidelines

1. **Security Considerations**
   - Review and modify scripts according to your security requirements
   - Test scripts in a non-production environment first
   - Ensure proper permissions are set before execution

2. **Performance Impact**
   - Some scripts may impact server performance
   - Schedule heavy operations during maintenance windows
   - Monitor system resources during execution

3. **Documentation**
   - Each script includes comments and documentation
   - Refer to included .docx files for detailed procedures
   - Check script headers for prerequisites and requirements

## Contributing

To contribute to this section:
1. Follow the main repository's contribution guidelines
2. Include proper documentation with your scripts
3. Test scripts thoroughly before submission
4. Update this README if adding new categories or significant features