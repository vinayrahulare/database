"""
This script generates a user creation script, a list of ALTER GROUP scripts, and an email template containing user credentials.

Sample Execution:
python Generate_user_pwd_email.py
Enter the username for the new user: test_user
Enter the schema names (comma-separated, e.g., 'billing_snapshots,data_ops,provider_payments'): "billing_snapshots","data_ops","provider_payments"

Output:
CREATE USER "test_user" PASSWORD 'Hidden1!';
ALTER GROUP billing_snapshots_ro ADD USER "test_user";
ALTER GROUP data_ops_ro ADD USER "test_user";
ALTER GROUP provider_payments_ro ADD USER "test_user";

Subject: Redshift Database Credentials

Hello,

Your database access has been set up. Below are your credentials:

Username: test_user
Password: Hidden1!
Server: redshift-cluster-1.abcdefg.us-east-1.redshift.amazonaws.com
Port: 5439
Database: dev
"""

import getpass
import secrets
import base64

def generate_random_password():
    """
    Generates a secure random password using Python's secrets module.
    """
    return base64.b64encode(secrets.token_bytes(16)).decode('utf-8')

def strip_and_parse_schemas(schemas_string):
    """
    Strips the double quotes and commas from a given string of schema names and returns a list of schema names.
    
    :param schemas_string: String of schema names, e.g. '"billing_snapshots","data_ops","provider_payments"'
    :return: List of schema names ['billing_snapshots', 'data_ops', 'provider_payments']
    """
    return schemas_string.replace('"', '').split(',')

def generate_create_user_script(username, password):
    """
    Generates SQL script to create a new user with a given username and password.
    
    :param username: The username of the new user
    :param password: The password for the new user
    :return: SQL statement for user creation
    """
    return f'CREATE USER "{username}" PASSWORD \'{password}\';'

def generate_alter_group_scripts(schemas, username):
    """
    Generates SQL statements to add the user to the pre-existing groups for each schema.
    
    :param schemas: List of schema names
    :param username: The username to be added to the groups
    :return: List of ALTER GROUP SQL statements
    """
    return [f'ALTER GROUP {schema}_ro ADD USER "{username}";' for schema in schemas]

def generate_email_template(username, password, server, port, db):
    """
    Generates an email template containing user credentials.
    
    :param username: The username of the new user
    :param password: The generated password
    :param server: The database server hostname
    :param port: The database port number
    :param db: The database name
    :return: A formatted email template
    """
    return f"""
    Subject: Redshift Database Credentials

    Hello,

    Your database access has been set up. Below are your credentials:

    Username: {username}
    Password: {password}
    Server: {server}
    Port: {port}
    Database: {db}

    Please use company VPN profile on Forticlient to connect to the database instance

    Best regards,
    Database Admin Team
    """

def print_scripts(schemas, username, password, server, port, db):
    """
    Prints the user creation script, ALTER GROUP scripts, and the email template.
    
    :param schemas: List of schema names
    :param username: The username of the new user
    :param password: The password for the new user
    :param server: Database server hostname
    :param port: Database port number
    :param db: Database name
    """
    print("\n--- SQL SCRIPTS ---\n")
    print(generate_create_user_script(username, password))
    for script in generate_alter_group_scripts(schemas, username):
        print(script)
    
    print("\n--- EMAIL TEMPLATE ---\n")
    print(generate_email_template(username, password, server, port, db))

def main():
    # Prompt for username input
    username = input("Enter the username for the new user: ")

    # Prompt for schema array input (comma-separated string)
    schemas_string = input("Enter the schema names (comma-separated, e.g., 'billing_snapshots,data_ops,provider_payments'): ")
    schemas = strip_and_parse_schemas(schemas_string)

    # Prompt for password option
    use_random_password = input("Generate a random password? (y/n): ").strip().lower()
    
    if use_random_password == 'y':
        password = generate_random_password()
    else:
        password = getpass.getpass("Enter a secure password: ")

    # Additional details for email template
    server = input("Enter the database server hostname: ")
    port = input("Enter the database port: ")
    db = input("Enter the database name: ")

    # Generate and print the scripts
    print_scripts(schemas, username, password, server, port, db)

if __name__ == "__main__":
    main()
