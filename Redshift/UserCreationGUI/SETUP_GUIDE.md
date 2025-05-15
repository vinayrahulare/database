# Redshift User Creation GUI - Setup Guide

This guide provides step-by-step instructions for setting up and running the Redshift User Creation GUI tool.

## System Requirements

- Windows or Mac operating system
- Python 3.6 or higher
- Internet connection (for package installation)

## Installation Steps

1. **Install Python** (if not already installed)
   - Download Python from [python.org](https://www.python.org/downloads/)
   - During installation, make sure to check "Add Python to PATH"
   - Verify installation by opening a terminal/command prompt and running:
     ```bash
     python --version
     ```

2. **Install Required Package**
   - Open a terminal/command prompt
   - Run the following command:
     ```bash
     pip install PyQt6
     ```
   - This will install the PyQt6 package required for the GUI

3. **Download the Tool**
   - Ensure you have the following files in your Redshift directory:
     - `user_creation_gui.py`
     - `GUI_README.md`

## Running the Tool

1. **Open Terminal/Command Prompt**
   - On Windows: Press `Windows + R`, type `cmd`, and press Enter
   - On Mac: Open Terminal from Applications > Utilities

2. **Navigate to the Tool Directory**
   ```bash
   cd path/to/Redshift
   ```

3. **Run the Application**
   ```bash
   python user_creation_gui.py
   ```

## Testing the Tool

1. **Basic Test**
   - Launch the application
   - Fill in the following test data:
     - Username: `test_user`
     - Check "Generate Random Password"
     - Server: `test-server.redshift.amazonaws.com`
     - Port: `5439`
     - Database: `test_db`
     - Schema names: `test_schema,public`
   - Click "Generate Scripts"
   - Verify that both SQL scripts and email template are generated

2. **Manual Password Test**
   - Clear all fields using the "Clear" button
   - Uncheck "Generate Random Password"
   - Enter a manual password
   - Fill in other fields as above
   - Verify that your manual password appears in the generated output

## Troubleshooting

1. **If PyQt6 installation fails:**
   ```bash
   python -m pip install --upgrade pip
   pip install PyQt6
   ```

2. **If the application doesn't start:**
   - Verify Python version: `python --version`
   - Verify PyQt6 installation: `pip list | findstr PyQt6`
   - Check if you're in the correct directory

3. **Common Issues:**
   - "ModuleNotFoundError: No module named 'PyQt6'"
     - Solution: Run `pip install PyQt6` again
   - "Python not found"
     - Solution: Ensure Python is added to PATH during installation

## Support

If you encounter any issues:
1. Check the [GUI_README.md](GUI_README.md) for detailed documentation
2. Contact the Database Admin Team for assistance

## Security Notes

- The tool generates secure random passwords using Python's `secrets` module
- All passwords are masked in the interface
- Generated credentials are only shown in the output area
- Always use secure passwords in production environments 