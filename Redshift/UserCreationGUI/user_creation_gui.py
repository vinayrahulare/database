import sys
import secrets
import base64
from PyQt6.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout, 
                            QHBoxLayout, QLabel, QLineEdit, QPushButton, 
                            QMessageBox, QTextEdit, QCheckBox, QGroupBox,
                            QComboBox)
from PyQt6.QtCore import Qt

class UserCreationApp(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Database User Creation Tool")
        self.setMinimumSize(800, 600)
        
        # Create central widget and layout
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        layout = QVBoxLayout(central_widget)
        
        # User Information Group
        user_group = QGroupBox("User Information")
        user_layout = QVBoxLayout()
        
        # Username input
        username_layout = QHBoxLayout()
        username_label = QLabel("Username:")
        self.username_input = QLineEdit()
        username_layout.addWidget(username_label)
        username_layout.addWidget(self.username_input)
        user_layout.addLayout(username_layout)
        
        # Password section
        password_layout = QHBoxLayout()
        self.use_random_password = QCheckBox("Generate Random Password")
        self.use_random_password.setChecked(True)
        self.password_input = QLineEdit()
        self.password_input.setEchoMode(QLineEdit.EchoMode.Password)
        self.password_input.setEnabled(False)
        password_layout.addWidget(self.use_random_password)
        password_layout.addWidget(self.password_input)
        user_layout.addLayout(password_layout)
        
        # Connect password checkbox
        self.use_random_password.stateChanged.connect(self.toggle_password_input)
        
        user_group.setLayout(user_layout)
        layout.addWidget(user_group)
        
        # Database Information Group
        db_group = QGroupBox("Database Information")
        db_layout = QVBoxLayout()
        
        # Server input with dropdown
        server_layout = QHBoxLayout()
        server_label = QLabel("Server Hostname:")
        self.server_combo = QComboBox()
        self.server_combo.setEditable(True)
        # Add predefined server options
        self.server_combo.addItems([
            "redshift.prod.company.com",
            "redshift.integration.company.com"
        ])
        # Add placeholder text for custom input
        self.server_combo.setCurrentText("")
        self.server_combo.setPlaceholderText("Select or enter server hostname")
        # Connect server selection to database name update
        self.server_combo.currentTextChanged.connect(self.update_database_name)
        server_layout.addWidget(server_label)
        server_layout.addWidget(self.server_combo)
        db_layout.addLayout(server_layout)
        
        # Port input
        port_layout = QHBoxLayout()
        port_label = QLabel("Port:")
        self.port_input = QLineEdit()
        self.port_input.setPlaceholderText("Default: 5439")
        port_layout.addWidget(port_label)
        port_layout.addWidget(self.port_input)
        db_layout.addLayout(port_layout)
        
        # Database name input
        db_name_layout = QHBoxLayout()
        db_name_label = QLabel("Database Name:")
        self.db_name_input = QLineEdit()
        self.db_name_input.setReadOnly(True)  # Make it read-only since it's auto-populated
        db_name_layout.addWidget(db_name_label)
        db_name_layout.addWidget(self.db_name_input)
        db_layout.addLayout(db_name_layout)
        
        db_group.setLayout(db_layout)
        layout.addWidget(db_group)
        
        # Schema Information Group
        schema_group = QGroupBox("Schema Access")
        schema_layout = QVBoxLayout()
        
        schema_label = QLabel("Enter schema names (comma-separated):")
        self.schema_input = QLineEdit()
        self.schema_input.setPlaceholderText("e.g., billing_snapshots,data_ops,provider_payments")
        schema_layout.addWidget(schema_label)
        schema_layout.addWidget(self.schema_input)
        
        schema_group.setLayout(schema_layout)
        layout.addWidget(schema_group)
        
        # Output Group
        output_group = QGroupBox("Generated Scripts")
        output_layout = QVBoxLayout()
        
        self.output_text = QTextEdit()
        self.output_text.setReadOnly(True)
        output_layout.addWidget(self.output_text)
        
        output_group.setLayout(output_layout)
        layout.addWidget(output_group)
        
        # Buttons
        button_layout = QHBoxLayout()
        generate_button = QPushButton("Generate Scripts")
        generate_button.clicked.connect(self.generate_scripts)
        clear_button = QPushButton("Clear")
        clear_button.clicked.connect(self.clear_inputs)
        button_layout.addWidget(generate_button)
        button_layout.addWidget(clear_button)
        
        layout.addLayout(button_layout)
    
    def update_database_name(self, server):
        """Update database name based on server selection"""
        if server == "redshift.prod.company.com":
            self.db_name_input.setText("prod")
        elif server == "redshift.integration.company.com":
            self.db_name_input.setText("dev")
        else:
            self.db_name_input.clear()
    
    def toggle_password_input(self, state):
        self.password_input.setEnabled(not state)
        if state:
            self.password_input.clear()
    
    def generate_random_password(self):
        return base64.b64encode(secrets.token_bytes(16)).decode('utf-8')
    
    def strip_and_parse_schemas(self, schemas_string):
        return schemas_string.replace('"', '').split(',')
    
    def generate_create_user_script(self, username, password):
        return f'CREATE USER "{username}" PASSWORD \'{password}\';'
    
    def generate_alter_group_scripts(self, schemas, username):
        return [f'ALTER GROUP {schema}_ro ADD USER "{username}";' for schema in schemas]
    
    def generate_email_template(self, username, password, server, port, db):
        return f"""
Subject: Redshift Database Credentials

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
    
    def generate_scripts(self):
        # Get input values
        username = self.username_input.text().strip()
        schemas_string = self.schema_input.text().strip()
        server = self.server_combo.currentText().strip()
        port = self.port_input.text().strip() or "5439"  # Default to 5439 if empty
        db = self.db_name_input.text().strip()
        
        # Validate inputs
        if not all([username, schemas_string, server, db]):
            QMessageBox.warning(self, "Input Error", "Please fill in all required fields.")
            return
        
        # Generate password
        if self.use_random_password.isChecked():
            password = self.generate_random_password()
        else:
            password = self.password_input.text()
            if not password:
                QMessageBox.warning(self, "Input Error", "Please enter a password or check 'Generate Random Password'.")
                return
        
        # Parse schemas
        schemas = self.strip_and_parse_schemas(schemas_string)
        
        # Generate output
        output = "--- SQL SCRIPTS ---\n\n"
        output += self.generate_create_user_script(username, password) + "\n"
        for script in self.generate_alter_group_scripts(schemas, username):
            output += script + "\n"
        
        output += "\n--- EMAIL TEMPLATE ---\n\n"
        output += self.generate_email_template(username, password, server, port, db)
        
        # Display output
        self.output_text.setText(output)
    
    def clear_inputs(self):
        self.username_input.clear()
        self.password_input.clear()
        self.server_combo.setCurrentText("")
        self.port_input.clear()
        self.db_name_input.clear()
        self.schema_input.clear()
        self.output_text.clear()
        self.use_random_password.setChecked(True)

def main():
    app = QApplication(sys.argv)
    window = UserCreationApp()
    window.show()
    sys.exit(app.exec())

if __name__ == "__main__":
    main() 