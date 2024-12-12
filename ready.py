import pyautogui
import time
import subprocess

def detect_button_via_script(script_name):
    """Run an external script to detect a button and keep trying until it succeeds."""
    while True:  # Loop until the button is found
        # Start the external script
        process = subprocess.Popen(['python3', script_name])
        process.wait()  # Wait for it to finish

        if process.returncode == 0:  # Check if the button was found
            print(f"Button in {script_name} detected and clicked!")
            return
        else:
            print(f"Button in {script_name} not detected, retrying...")
            time.sleep(2)  # Wait 2 seconds before retrying detection

if __name__ == "__main__":
    # Step 1: Detect the desktop button via desktop.py script
    detect_button_via_script('desktop.py')

    # Step 2: Perform additional desktop actions after detecting the desktop button
    print("Performing desktop actions...")
    time.sleep(4)
    # Perform click at (22, 600)
    pyautogui.click(1360,414)
    time.sleep(1)
    pyautogui.click(35, 420)

    # Press up arrow 4 times, right arrow once, down arrow once, and Enter
    for _ in range(4):
        pyautogui.press("up")
    pyautogui.press("right")
    pyautogui.press("down")
    pyautogui.press("enter")
    time.sleep(2)
    pyautogui.write("wget https://raw.githubusercontent.com")
    pyautogui.press("enter")
    time.sleep(3)
    pyautogui.write("bash script.sh")
    pyautogui.press("enter")
    time.sleep(2)
    print("Desktop actions completed.")
    
