# MySQL Administration Tools

This directory contains scripts and tools for managing MySQL databases, focusing on high availability, replication, and environment-specific configurations.

## Table of Contents
- [High Availability](#high-availability)
- [Environment Configurations](#environment-configurations)
- [Replication Management](#replication-management)
- [Usage Guidelines](#usage-guidelines)
- [Contributing](#contributing)

## High Availability

### Failover Management
- `failover.sh` - Automated failover script
  - Handles master-replica failover
  - Ensures data consistency
  - Manages replication flow reversal
  - Includes safety checks and validations
  - Supports automated and manual intervention points

## Environment Configurations

### Production Mirror
Located in `ProdMirror/`:
- `mysqld_setenv.sh` - Environment configuration
- `mysqld.service` - Service configuration
- `my.cnf` - MySQL server configuration
- `genetar_replication_statement.sh` - Replication setup
- `create_ProdMirror_users.txt` - User management

### Enterprise Data Warehouse
Located in `EDW/`:
- Enterprise Data Warehouse configurations
- Data integration scripts
- ETL process management

### Enterprise Data Services
Located in `EDS/`:
- Data service configurations
- API integration scripts
- Service management tools

### Regional Configurations
- `DENMARK_REFRESH_TARGET/` - Denmark-specific configurations
- `CANADA_REFRESH_TARGET/` - Canada-specific configurations
- `CANADA_REFRESH/` - Canada refresh procedures

## Replication Management

### Configuration
- Server configuration templates
- Replication setup scripts
- User permission management
- Service configuration files

### Monitoring
- Replication status checks
- Lag monitoring
- Error detection
- Performance tracking

## Usage Guidelines

1. **Failover Procedures**
   ```bash
   # Execute failover from current master to replica
   ./failover.sh <currentMaster> <currentSlave>
   ```
   - Review failover prerequisites
   - Verify replication status
   - Monitor failover progress
   - Validate new configuration

2. **Environment Setup**
   - Use appropriate configuration files
   - Follow naming conventions
   - Document all changes
   - Test in non-production first

3. **Security Considerations**
   - Secure credential management
   - Proper user permissions
   - Network security
   - Access control

4. **Best Practices**
   - Regular maintenance
   - Performance monitoring
   - Backup verification
   - Documentation updates

## Script Usage Examples

### Failover Execution
```bash
# Basic failover
./failover.sh master.example.com replica.example.com

# With monitoring
./failover.sh master.example.com replica.example.com | tee failover.log
```

### Replication Setup
```bash
# Generate replication statements
./genetar_replication_statement.sh

# Apply configuration
./mysqld_setenv.sh
```

## Contributing

To contribute to this section:
1. Follow the main repository's contribution guidelines
2. Include proper documentation with your scripts
3. Test scripts thoroughly before submission
4. Update this README if adding new categories or significant features 