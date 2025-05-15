# Redshift User Creation Web Tool

A web-based tool for creating Redshift users and generating SQL scripts and email templates.

## Features

- Modern, responsive web interface
- Automatic database name selection based on server
- Random password generation
- SQL script generation for user creation and group alterations
- Email template generation with connection details
- Input validation and error handling

## Setup Instructions

1. Install Python 3.8 or higher if not already installed
2. Create a virtual environment (recommended):
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

## Running the Application

1. Start the Flask server:
   ```bash
   python web_app.py
   ```
2. Open your web browser and navigate to:
   ```
   http://localhost:5000
   ```

## Usage

1. Enter the username for the new Redshift user
2. Choose whether to generate a random password or enter a custom one
3. Select the server from the dropdown menu
   - The database name will be automatically set based on the server selection
4. Enter the port (defaults to 5439 if left empty)
5. Enter comma-separated schema names
6. Click "Generate Scripts" to create the SQL scripts and email template
7. Use the "Clear" button to reset the form

## Server-Database Mapping

- `redshift.prod.company.com` → `prod` database
- `redshift.integration.company.com` → `dev` database

## Production Deployment

For production deployment on Ubuntu 22.04:

1. Install required system packages:
   ```bash
   sudo apt update
   sudo apt install python3-venv nginx
   ```

2. Set up a systemd service:
   ```bash
   sudo nano /etc/systemd/system/redshift-user-tool.service
   ```
   Add the following content:
   ```ini
   [Unit]
   Description=Redshift User Creation Web Tool
   After=network.target

   [Service]
   User=your_username
   WorkingDirectory=/path/to/Redshift/UserCreationGUI
   Environment="PATH=/path/to/Redshift/UserCreationGUI/venv/bin"
   ExecStart=/path/to/Redshift/UserCreationGUI/venv/bin/python web_app.py
   Restart=always

   [Install]
   WantedBy=multi-user.target
   ```

3. Configure Nginx:
   ```bash
   sudo nano /etc/nginx/sites-available/redshift-user-tool
   ```
   Add the following configuration:
   ```nginx
   server {
       listen 80;
       server_name your_domain.com;

       location / {
           proxy_pass http://127.0.0.1:5000;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
       }
   }
   ```

4. Enable the site and restart services:
   ```bash
   sudo ln -s /etc/nginx/sites-available/redshift-user-tool /etc/nginx/sites-enabled
   sudo systemctl start redshift-user-tool
   sudo systemctl enable redshift-user-tool
   sudo systemctl restart nginx
   ```

## Security Considerations

- The application should be deployed behind HTTPS in production
- Keep the application and its dependencies up to date
- Monitor server logs for any suspicious activity

## Troubleshooting

- Check the application logs:
  ```bash
  sudo journalctl -u redshift-user-tool
  ```
- Check Nginx logs:
  ```bash
  sudo tail -f /var/log/nginx/error.log
  ```
- Ensure the virtual environment is activated when running the application
- Verify that all required ports are open in your firewall 