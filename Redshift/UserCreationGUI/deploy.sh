#!/bin/bash

# Exit on error
set -e

echo "Starting deployment of Redshift User Creation Tool..."

# Set application port
export REDSHIFT_TOOL_PORT=1100

# Update system packages with error handling
echo "Updating system packages..."
sudo sed -i 's/azure.archive.ubuntu.com/archive.ubuntu.com/g' /etc/apt/sources.list
sudo apt update || {
    echo "Warning: Initial update failed, trying with default repositories..."
    sudo sed -i 's/azure.archive.ubuntu.com/archive.ubuntu.com/g' /etc/apt/sources.list
    sudo apt update
}

# Install required system packages with error handling
echo "Installing required system packages..."
sudo apt install -y python3-venv nginx || {
    echo "Error: Failed to install required packages"
    echo "Trying alternative installation method..."
    sudo apt update --fix-missing
    sudo apt install -y python3-venv nginx
}

# Create application directory
echo "Creating application directory..."
sudo mkdir -p /opt/redshift-user-tool
sudo chown $USER:$USER /opt/redshift-user-tool

# Copy application files
echo "Copying application files..."
cp -r ./* /opt/redshift-user-tool/

# Create and activate virtual environment
echo "Setting up Python virtual environment..."
cd /opt/redshift-user-tool
python3 -m venv venv
source venv/bin/activate

# Install Python dependencies
echo "Installing Python dependencies..."
pip install -r requirements.txt

# Create systemd service file
echo "Creating systemd service..."
sudo tee /etc/systemd/system/redshift-user-tool.service << EOF
[Unit]
Description=Redshift User Creation Web Tool
After=network.target

[Service]
User=$USER
WorkingDirectory=/opt/redshift-user-tool
Environment="PATH=/opt/redshift-user-tool/venv/bin"
Environment="REDSHIFT_TOOL_PORT=$REDSHIFT_TOOL_PORT"
ExecStart=/opt/redshift-user-tool/venv/bin/python web_app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Stop and clean up any existing Nginx processes
echo "Cleaning up existing Nginx processes..."
sudo systemctl stop nginx || true
sudo pkill nginx || true
sudo fuser -k 80/tcp || true

# Create Nginx configuration
echo "Configuring Nginx..."
sudo tee /etc/nginx/sites-available/redshift-user-tool << EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:$REDSHIFT_TOOL_PORT;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }

    location /health {
        proxy_pass http://127.0.0.1:$REDSHIFT_TOOL_PORT/health;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        access_log off;
    }
}
EOF

# Enable Nginx site
echo "Enabling Nginx site..."
sudo ln -sf /etc/nginx/sites-available/redshift-user-tool /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default  # Remove default site

# Test Nginx configuration
echo "Testing Nginx configuration..."
sudo nginx -t

# Start and enable services
echo "Starting services..."
sudo systemctl daemon-reload
sudo systemctl start redshift-user-tool
sudo systemctl enable redshift-user-tool

# Start Nginx with retry
echo "Starting Nginx..."
for i in {1..3}; do
    if sudo systemctl start nginx; then
        echo "Nginx started successfully"
        break
    else
        echo "Attempt $i: Failed to start Nginx, waiting 5 seconds..."
        sleep 5
        sudo systemctl stop nginx || true
        sudo pkill nginx || true
        sudo fuser -k 80/tcp || true
    fi
done

# Wait for application to start and check health
echo "Checking application health..."
sleep 5
if curl -s http://localhost/health | grep -q "healthy"; then
    echo "Application is healthy and running"
else
    echo "Warning: Health check failed, please check the application logs"
fi

# Final status check
echo "Checking service status..."
sudo systemctl status nginx --no-pager
sudo systemctl status redshift-user-tool --no-pager

echo "Deployment completed successfully!"
echo "The application is now running at http://localhost"
echo "Health check available at http://localhost/health"
echo "To check the status, run: sudo systemctl status redshift-user-tool" 