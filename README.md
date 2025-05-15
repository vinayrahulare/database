# Database Management Scripts Repository

This repository contains a collection of database management scripts and tools for various database platforms, focusing on administration, monitoring, and maintenance tasks.

## Repository Structure

The repository is organized into the following main sections:

### Database Platforms
- [MySQL](./MySQL/README.md) - MySQL database administration scripts
- [PostgreSQL](./PostgreSQL/README.md) - PostgreSQL database management tools
- [Aurora](./Aurora/README.md) - Amazon Aurora management scripts
- [Redshift](./Redshift/README.md) - Amazon Redshift management tools
- [SQLServer](./SQLServer/README.md) - Microsoft SQL Server administration scripts

### Scripts
- [Scripts](./Scripts/) - General database management scripts

## Platform-Specific Tools

### MySQL
The MySQL directory contains scripts for:
- Lock monitoring and management
  - `locked.sql` - View currently locked tables
  - `locking.sql` - Monitor locking operations
  - `locks_on_a_table.sql` - Check locks on specific tables
  - `transactions_waiting.sql` - Monitor waiting transactions

### PostgreSQL
The PostgreSQL directory includes:
- Database maintenance scripts
  - `vacuum_analyze_schema.sh` - Perform VACUUM ANALYZE operations
  - `terminate_long_running_queries.sh` - Manage long-running queries

### Aurora
Amazon Aurora management scripts for:
- Cluster management
- Performance monitoring
- Backup and recovery

### Redshift
Amazon Redshift tools for:
- Data warehouse management
- Performance optimization
- User and permission management

### SQLServer
Microsoft SQL Server administration scripts for:
- Database maintenance
- Performance tuning
- Security management

## General Scripts
The Scripts directory contains cross-platform database management tools and utilities.

## Setup and Usage

1. Clone the repository:
```bash
git clone https://github.com/vinayrahulare/database.git
```

2. Navigate to the repository:
```bash
cd database
```

3. Each platform directory contains its own README.md with specific setup instructions and usage guidelines.

## Prerequisites

- Database client tools for respective platforms
- Shell environment (bash/zsh)
- Appropriate database credentials and permissions
- AWS CLI (for AWS-related scripts)

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes
4. Push to your fork
5. Create a pull request

## License

This project is licensed under the terms of the included LICENSE file.

## Security

- Never commit sensitive information like passwords or API keys
- Use environment variables or secure credential management
- Follow the principle of least privilege when setting up database access

## Support

For issues and feature requests, please create an issue in the GitHub repository.
