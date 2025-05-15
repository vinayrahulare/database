# Redshift User Creation Tool

A graphical user interface (GUI) tool for creating Redshift database users and generating necessary SQL scripts and email templates.

## Features

- User-friendly interface for database user creation
- Automatic random password generation
- Manual password input option
- Schema access management
- SQL script generation
- Email template generation with credentials
- Cross-platform compatibility (Windows and Mac)

## Prerequisites

- Python 3.6 or higher
- PyQt6

## Installation

1. Install the required Python package:
```bash
pip install PyQt6
```

## Usage

1. Navigate to the Redshift directory:
```bash
cd Redshift
```

2. Run the application:
```bash
python user_creation_gui.py
```

3. Fill in the required information:
   - Username
   - Password (or use random password generation)
   - Server hostname
   - Port
   - Database name
   - Schema names (comma-separated)

4. Click "Generate Scripts" to create:
   - SQL user creation script
   - ALTER GROUP scripts for schema access
   - Email template with credentials

## Input Fields

### User Information
- **Username**: The username for the new database user
- **Password**: Either manually enter a password or use the "Generate Random Password" option

### Database Information
- **Server Hostname**: The Redshift cluster endpoint
- **Port**: The database port number
- **Database Name**: The name of the database

### Schema Access
- **Schema Names**: Comma-separated list of schemas the user should have access to
  - Example: `billing_snapshots,data_ops,provider_payments`

## Output

The tool generates two types of output:

1. **SQL Scripts**:
   - CREATE USER statement
   - ALTER GROUP statements for each schema

2. **Email Template**:
   - Formatted email with all necessary connection information
   - Includes VPN connection instructions

## Security Notes

- Passwords are masked in the interface
- Random passwords are generated using Python's `secrets` module
- All credentials are displayed only in the generated output

## Support

For any issues or questions, please contact the Database Admin Team. 