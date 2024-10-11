import pyautogui
import time
import random
import subprocess  # To run external scripts like 'press.py'

# Function to perform a random click from a list of coordinates
def random_click(locations):
    x, y = random.choice(locations)
    pyautogui.click(x, y)
time.sleep(3)    
# New Step: Detect the tab button using 'tab_button.png'
try:
    tab_button_location = pyautogui.locateCenterOnScreen('tab_button.png', confidence=0.8)
    if tab_button_location is not None:
        print("Tab button detected, clicking at (1342, 125)...")
        click_at(1342, 125)
        time.sleep(2)
    else:
        print("Tab button not detected, proceeding to Step 1...")
except Exception as e:
    print(f"Error detecting tab button: {e}")
    print("Proceeding to Step 1...")
# Task 1: Open www.datalore.jetbrains.com
time.sleep(2)
pyautogui.click(306, 81)  # Click location (x:306, y:81)
pyautogui.write("datalore.jetbrains.com")  # Type URL
pyautogui.press('enter')  # Press Enter
time.sleep(20)  # Wait for webpage to finish loading (20 seconds)

# Task 2: Perform random mouse clicks on first set of locations
first_set_locations = [(1172, 179), (1188, 178), (1206, 179), (1219, 182), 
                       (1235, 178), (1249, 179), (1255, 181), (1214, 184)]
random_click(first_set_locations)  # Click random location
time.sleep(2)  # Wait for 2 seconds

# Perform random mouse clicks on second set of locations
second_set_locations = [(255, 396), (267, 397), (276, 398), (289, 397),
                        (298, 396), (311, 398), (324, 399), (340, 397), (292, 406)]
random_click(second_set_locations)  # Click random location
time.sleep(40)  # Wait for webpage to finish loading (40 seconds)

# Task 3: Click on location, tab 14 times, enter 2 times
pyautogui.click(1341, 84)  # Click location (x:1341, y:84)
time.sleep(2)
pyautogui.press('tab', presses=14, interval=0.2)  # Press Tab 14 times
time.sleep(1)
pyautogui.press('enter', presses=2, interval=0.5)  # Press Enter 2 times
time.sleep(2)

# Task 4: Click location, perform random click, type wget command
pyautogui.click(297, 175)  # Click location (x:297, y:175)
time.sleep(2)
third_set_locations = [(299, 413), (314, 413), (328, 413), (349, 414),
                       (366, 412), (326, 413), (316, 413)]
random_click(third_set_locations)  # Click random location
time.sleep(2)

# Write and execute commands
pyautogui.write("wget https://raw.githubusercontent.com/Fiujol/upload/refs/heads/main/docker.sh")
time.sleep(2)
pyautogui.press('enter')  # Press Enter
time.sleep(5)
pyautogui.write("bash docker.sh")
time.sleep(2)
pyautogui.press('enter')  # Press Enter

# Final wait (3 minutes)
time.sleep(180)

# New tasks
# Task 5: Mouse click at (x:594, y:274) and random clicks
pyautogui.click(594, 274)  # Click location (x:594, y:274)
time.sleep(1)

# Perform random mouse clicks on fourth set of locations
fourth_set_locations = [(416, 317), (428, 318), (440, 317), (451, 317),
                        (459, 318), (475, 317), (492, 317), (513, 315), (465, 317)]
random_click(fourth_set_locations)  # Click random location
time.sleep(2)

# Task 6: Click on location (x:291, y:41) and paste clipboard content
pyautogui.click(291, 41)  # Click location (x:291, y:41)
time.sleep(1)
pyautogui.hotkey('ctrl', 'v')  # Perform Ctrl+V (paste)
time.sleep(1)
pyautogui.press('enter')  # Press Enter
time.sleep(15)  # Wait for 15 seconds

# Task 7: Write "!openport --local-port 6200" and press Enter
pyautogui.write("!openport --local-port 6200")  # Write command
time.sleep(2)
pyautogui.click(275, 278)  # Click location (x:275, y:278)
time.sleep(8)  # Wait for 8 seconds

# Task 8: Run Python script 'press.py'
subprocess.run(["python3", "press.py"])  # Run the script
time.sleep(4)  # Wait for 4 seconds
