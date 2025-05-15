"""
This script generates a user creation script and a list of ALTER GROUP scripts to add the user to the corresponding groups.

Sample Execution:
python Generate_user_creation_script.py
Enter the username for the new user: test_user
Enter the schema names (comma-separated, e.g., 'billing_snapshots,data_ops,provider_payments'): "billing_snapshots","data_ops","provider_payments"

Output:
CREATE USER "test_user" PASSWORD 'Hidden1!';
ALTER GROUP billing_snapshots_ro ADD USER "test_user";
ALTER GROUP data_ops_ro ADD USER "test_user";
ALTER GROUP provider_payments_ro ADD USER "test_user";

"""

def strip_and_parse_schemas(schemas_string):
    """
    Strips the double quotes and commas from a given string of schema names and returns a list of schema names.
    
    :param schemas_string: String of schema names, e.g. '"billing_snapshots","data_ops","provider_payments"'
    :return: List of schema names ['billing_snapshots', 'data_ops', 'provider_payments']
    """
    schemas_list = schemas_string.replace('"', '').split(',')
    return schemas_list

def generate_create_user_script(username, password):
    """
    Generates SQL script to create a new user with a given username and password.
    
    :param username: The username of the new user
    :param password: The password for the new user
    :return: SQL statement for user creation
    """
    create_user_script = f'CREATE USER "{username}" PASSWORD \'{password}\';'
    return create_user_script

def generate_alter_group_scripts(schemas, username):
    """
    Generates SQL statements to add the user to the pre-existing groups for each schema.
    
    :param schemas: List of schema names
    :param username: The username to be added to the groups
    :return: List of ALTER GROUP SQL statements
    """
    alter_group_scripts = []
    for schema in schemas:
        group_name = f"{schema}_ro"  # Dynamically generate the group name (e.g., "pii_ro")
        alter_group_script = f'ALTER GROUP {group_name} ADD USER "{username}";'
        alter_group_scripts.append(alter_group_script)
    return alter_group_scripts

def print_scripts(schemas, username, password):
    """
    Prints the user creation script and the ALTER GROUP scripts to add the user to the corresponding groups.
    
    :param schemas: List of schema names
    :param username: The username of the new user
    :param password: The password for the new user
    """
    print(generate_create_user_script(username, password))
    alter_group_scripts = generate_alter_group_scripts(schemas, username)
    for script in alter_group_scripts:
        print(script)

def main():
    # Prompt for username input
    username = input("Enter the username for the new user: ")
    
    # Prompt for schema array input (comma-separated string)
    schemas_string = input("Enter the schema names (comma-separated, e.g., 'billing_snapshots,data_ops,provider_payments'): ")
    
    # Strip and parse the schema names
    schemas = strip_and_parse_schemas(schemas_string)
    
    # Set the password (or prompt for it if you'd like)
    password = "Hidden1!"  # You can customize this if needed
    
    # Generate and print the scripts
    print_scripts(schemas, username, password)

if __name__ == "__main__":
    main()
