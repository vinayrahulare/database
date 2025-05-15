# SQL Scripts Repository

This directory contains a collection of SQL scripts organized by database platform. These scripts are designed for various database administration tasks, monitoring, and maintenance operations.

## Table of Contents
- [MySQL Scripts](#mysql-scripts)
- [RedShift Scripts](#redshift-scripts)
- [PostgreSQL Scripts](#postgresql-scripts)
- [Usage Guidelines](#usage-guidelines)
- [Contributing](#contributing)

## MySQL Scripts

Located in `MySQL/` directory:

### User Management
- `user-extraction-script-audit-MM-EDS-EDW-Eligibility.sql` - User extraction and audit
- `user_connection_type.sql` - Connection type analysis

### Performance Monitoring
- `innodb_lock_waits.sql` - InnoDB lock wait analysis

### Application-Specific Scripts
- `MemberMaster/` - Member Master database scripts
- `EDS/` - Enterprise Data Services scripts
- `CCM/` - Customer Care Management scripts

## RedShift Scripts

Located in `RedShift/` directory:

### Application Scripts
- `LVG/` - company-specific scripts and queries

## PostgreSQL Scripts

Located in `Postgres/` directory:

### Database Administration
- `Useful_Admin_Queries.sql` - Collection of administrative queries
  - User management
  - Performance monitoring
  - Space utilization
  - Connection tracking

### Schema Management
- `List_Foreign_Keys_and_Indices.sql` - Foreign key and index analysis
  - Foreign key relationships
  - Index usage
  - Constraint management

## Usage Guidelines

1. **Script Selection**
   - Choose scripts based on your database platform
   - Verify script compatibility with your version
   - Review script documentation
   - Test in non-production environment first

2. **Execution Environment**
   - Ensure proper database permissions
   - Verify connection parameters
   - Check resource availability
   - Monitor execution impact

3. **Security Considerations**
   - Review scripts for sensitive data
   - Use appropriate access controls
   - Implement proper error handling
   - Log script execution

4. **Best Practices**
   - Document script modifications
   - Version control all changes
   - Regular script review
   - Performance impact assessment

## Script Usage Examples

### MySQL User Audit
```sql
-- Execute user extraction script
source user-extraction-script-audit-MM-EDS-EDW-Eligibility.sql
```

### PostgreSQL Admin Queries
```sql
-- Run administrative queries
\i Useful_Admin_Queries.sql
```

### RedShift Analysis
```sql
-- Execute LVG-specific queries
\i LVG/analysis_queries.sql
```

## Contributing

To contribute to this section:
1. Follow the main repository's contribution guidelines
2. Organize scripts by database platform
3. Include proper documentation
4. Test scripts thoroughly
5. Update this README when adding new categories

### Script Documentation Requirements
- Purpose and functionality
- Required permissions
- Expected output
- Dependencies
- Version compatibility
- Usage examples 