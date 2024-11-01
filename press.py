import pyautogui
import time
import pyperclip
import re
import subprocess

# Define the coordinates for the mouse click
x1, y1 = 178, 333
x2, y2 = 252, 40
x3, y3 = 290, 42

# Click at the first coordinates to select text
pyautogui.click(x1, y1)

# Hold down the 'shift' key to start selecting
pyautogui.keyDown('shift')

# Wait for 1 second while holding 'shift'
time.sleep(1)

# Press the down arrow key 4 times while holding 'shift'
for _ in range(4):
    pyautogui.press('down')

# Release the 'shift' key
pyautogui.keyUp('shift')

# Press 'Ctrl + C' to copy the selected text to the clipboard
pyautogui.hotkey('ctrl', 'c')

# Wait a moment to ensure the clipboard operation completes
time.sleep(0.5)

# Get the copied text from the clipboard
copied_text = pyperclip.paste()

# Define the updated pattern to match
pattern = r'(https://openport\.io/l/)(\d+)(/[A-Za-z0-9]*)'

# Search for the pattern in the copied text
match = re.search(pattern, copied_text)

if match:
    # Construct the new URL
    new_url = f"{match.group(1)}{match.group(2)}{match.group(3)}"
    
    # Copy the new URL to the clipboard using pyperclip
    pyperclip.copy(new_url)
    print(f"Extracted URL: {new_url}")
else:
    print("No matching pattern found.")

# Now perform additional tasks as requested
# Sleep for 2 seconds
time.sleep(2)

# Perform the first mouse click at (x:252, y:40)
pyautogui.click(x2, y2)

# Sleep for 2 seconds
time.sleep(2)

# Perform the second mouse click at (x:290, y:42)
pyautogui.click(x3, y3)

# Sleep for 2 seconds
time.sleep(2)
pyautogui.press('f12')
time.sleep(4)
pyautogui.click(1302, 221)
time.sleep(2)
pyautogui.click(456, 195)
time.sleep(1)
pyautogui.hotkey('ctrl', 'a')
time.sleep(1)
pyautogui.write("1366")
time.sleep(1)
pyautogui.click(506, 196)
time.sleep(1)
pyautogui.hotkey('ctrl', 'a')
time.sleep(1)
pyautogui.write("641")
time.sleep(1)
pyautogui.click(1180, 199)
time.sleep(1)
pyautogui.click(1354, 220)
time.sleep(1)
pyautogui.click(290,82)
time.sleep(1)
# Press 'Ctrl + V' to paste the clipboard content
pyautogui.hotkey('ctrl', 'v')

# Sleep for 1 second
time.sleep(1)

# Press 'Enter' to submit
pyautogui.press('enter')

# Wait for 5 seconds for the page to finish loading
time.sleep(5)

# Press 'Tab' once
pyautogui.press('tab')

# Press 'Enter'
pyautogui.press('enter')

# Finally, run the python script ready.py using subprocess
subprocess.run(['python3', 'ready.py'])
