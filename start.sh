#!/bin/bash
# Run setup script
bash setup.sh

# Activate the Python virtual environment
source ./myenv/bin/activate

# Check if activation was successful
if [ $? -ne 0 ]; then
  echo "Failed to activate the virtual environment."
  exit 1
fi

# Ensure .Xauthority exists
touch ~/.Xauthority

# Install necessary Python packages
pip install pyautogui
pip install --upgrade pillow
pip install opencv-python-headless
pip install pyperclip

# Run gofile.sh script
bash gofile.sh

# Check if gofile.sh executed successfully
if [ $? -ne 0 ]; then
  echo "gofile.sh failed to execute."
  exit 1
fi

# Run the Python script directly
python3 datalore.py

# Check if datalore.py executed successfully
if [ $? -ne 0 ]; then
  echo "datalore.py failed to execute."
  exit 1
fi
python3 newtab.py
python3 extension.py
echo "Both gofile.sh and datalore.py executed successfully."
