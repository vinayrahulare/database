from flask import Flask, render_template, request, jsonify
import secrets
import base64

app = Flask(__name__)

def generate_random_password():
    """Generates a secure random password using Python's secrets module."""
    return base64.b64encode(secrets.token_bytes(16)).decode('utf-8')

def strip_and_parse_schemas(schemas_string):
    """Strips the double quotes and commas from a given string of schema names."""
    return schemas_string.replace('"', '').split(',')

def generate_create_user_script(username, password):
    """Generates SQL script to create a new user."""
    return f'CREATE USER "{username}" PASSWORD \'{password}\';'

def generate_alter_group_scripts(schemas, username):
    """Generates SQL statements to add the user to the pre-existing groups."""
    return [f'ALTER GROUP {schema}_ro ADD USER "{username}";' for schema in schemas]

def generate_email_template(username, password, server, port, db):
    """Generates an email template containing user credentials."""
    return f"""
SECURE: Redshift Database Credentials

Hello,

Your database access has been set up. Below are your credentials:

Username: {username}
Password: {password}
Server: {server}
Port: {port}
Database: {db}

Please use company VPN profile to connect to the database instance

Best regards,
Database Admin Team
"""

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/generate', methods=['POST'])
def generate():
    data = request.json
    
    # Get input values
    username = data.get('username', '').strip()
    schemas_string = data.get('schemas', '').strip()
    server = data.get('server', '').strip()
    port = data.get('port', '').strip() or "5439"
    use_random_password = data.get('useRandomPassword', True)
    password = data.get('password', '').strip()
    
    # Set database based on server
    if server == "redshift.prod.company.com":
        db = "prod"
    elif server == "redshift.integration.company.com":
        db = "dev"
    else:
        db = ""
    
    # Validate inputs
    if not all([username, schemas_string, server, db]):
        return jsonify({
            'error': 'Please fill in all required fields.'
        }), 400
    
    # Generate password
    if use_random_password:
        password = generate_random_password()
    elif not password:
        return jsonify({
            'error': 'Please enter a password or check "Generate Random Password".'
        }), 400
    
    # Parse schemas
    schemas = strip_and_parse_schemas(schemas_string)
    
    # Generate output
    sql_scripts = []
    sql_scripts.append(generate_create_user_script(username, password))
    sql_scripts.extend(generate_alter_group_scripts(schemas, username))
    
    email_template = generate_email_template(username, password, server, port, db)
    
    return jsonify({
        'sql_scripts': sql_scripts,
        'email_template': email_template
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True) 