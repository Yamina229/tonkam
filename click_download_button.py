import pyautogui
import time
 
def is_element_on_screen(image_path, confidence=0.8):
    """
    Check if a visual element is on the screen.
 
    :param image_path: Path to the screenshot of the element.
    :param confidence: Matching confidence for pyautogui (between 0 and 1).
    :return: The location of the element if found, or None if not found.
    """
    return pyautogui.locateCenterOnScreen(image_path, confidence=confidence)
 
def scroll_and_search(image_path, confidence=0.8, timeout=120):
    """
    Scroll down the page using arrow keys and search for the download button.
 
    :param image_path: Path to the screenshot of the element.
    :param confidence: Matching confidence for pyautogui (between 0 and 1).
    :param timeout: How long to wait for the element before giving up (seconds).
    :return: The location of the element if found, or None if not found.
    """
    print(f"Waiting for element '{image_path}' to appear on the screen...")
    start_time = time.time()
 
    # Press the down arrow key twice to scroll down
    pyautogui.press('down')
    time.sleep(1)  # Wait for the page to adjust after scrolling
    pyautogui.press('down')
    time.sleep(1)  # Wait for the page to adjust after scrolling
 
    # Check for the button on the screen
    button_location = is_element_on_screen(image_path, confidence)
 
    if button_location is not None:
        print(f"Element found at: {button_location}")
        return button_location
 
    print("Element not found after scrolling.")
    return None
 
def click_download_button(download_button_image):
    """
    Wait for the download button to appear, then click it.
 
    :param download_button_image: Path to the download button screenshot.
    """
    button_location = scroll_and_search(download_button_image)
 
    if button_location is not None:
        print(f"Download button found at: {button_location}. Clicking now...")
        pyautogui.moveTo(button_location)
        pyautogui.click()
    else:
        print("Download button not found. Exiting.")
 
# Path to the screenshot of the download button (update with the correct path)
download_button_image = 'download_button.png'
 
# Call the function to wait for and click the download button
click_download_button(download_button_image)
 
print("Process complete.")
