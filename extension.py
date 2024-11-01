import pyautogui
import time
import subprocess

# Step 1: Initial sleep for 2 seconds
time.sleep(2)

# Step 2: Click at (964, 45)
pyautogui.hotkey('ctrl', 't')

# Step 3: Sleep for 2 seconds
time.sleep(2)

# Step 4: Type the URL for the Firefox add-on
pyautogui.write("https://addons.mozilla.org/nl/firefox/addon/auto-refresh-page/")

# Step 5: Sleep for 1 second
time.sleep(1)

# Step 6: Press Enter
pyautogui.press("enter")

# Step 7: Sleep for 6 seconds to allow the page to load
time.sleep(6)
pyautogui.click(89, 276)
time.sleep(2)
# Step 8: Press Tab 13 times, with a 1-second delay between each press
for _ in range(13):
    pyautogui.press("tab")
    time.sleep(1)

# Step 9: Press Enter
pyautogui.press("enter")

# Step 10: Sleep for 3 seconds
time.sleep(3)
pyautogui.click(1273, 326)
time.sleep(1)
pyautogui.click(1307, 207)
time.sleep(1)
pyautogui.click(1265, 41)
time.sleep(1)
pyautogui.click(1266, 42)
time.sleep(1)
pyautogui.click(1155, 40)
time.sleep(1)
pyautogui.click(1308, 82)
time.sleep(1)
pyautogui.click(1297, 186)
time.sleep(1)
pyautogui.click(1135, 254)
time.sleep(2)
pyautogui.click(1307, 85)
time.sleep(1)
pyautogui.press("delete")
time.sleep(1)
pyautogui.write("150")
time.sleep(1)
pyautogui.click(401, 164)
time.sleep(1)
pyautogui.click(1284, 345)
time.sleep(1)
pyautogui.click(1292, 375)
time.sleep(1)
for _ in range(4):
    pyautogui.press("down")
    time.sleep(1)
pyautogui.click(991, 401)
time.sleep(1)
pyautogui.click(1271, 192)
time.sleep(1)
pyautogui.click(621, 38)
time.sleep(1)
pyautogui.click(1323, 10)
time.sleep(1)
