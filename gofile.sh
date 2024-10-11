#!/bin/bash

# URL of the central server that provides the unique link
SERVER_URL="https://9776b5d1-e199-4b8e-a8d7-ccb31c3adc5a.deepnoteproject.com/get_url"

# Make a request to the server and get the JSON response
response=$(curl -s $SERVER_URL)

# Extract the URL from the JSON response using jq
url=$(echo $response | jq -r .url)

# Check if a valid URL is received
if [ "$url" != "null" ]; then
    echo "Received URL: $url"
    
    # Copy the URL to the clipboard using xclip
    echo -n "$url" | xclip -selection clipboard
    
    echo "URL copied to clipboard."
    
    # Create a temporary Firefox profile to avoid session restore issues
    TEMP_PROFILE=$(mktemp -d)
    echo "Created temporary profile: $TEMP_PROFILE"
    
    # Disable Firefox session restore and startup homepage for the temporary profile
    cat <<EOF > "$TEMP_PROFILE/user.js"
user_pref("browser.sessionstore.resume_from_crash", false);
user_pref("browser.startup.page", 0);  # 0 means a blank page at startup
user_pref("browser.startup.homepage_override.mstone", "ignore");  # Prevent first-run tabs
user_pref("browser.tabs.warnOnClose", false);  # Prevent warnings on tab closure
user_pref("browser.warnOnQuit", false);  # Prevent warnings on quitting
user_pref("browser.sessionstore.max_tabs_undo", 0);  # No tab history restore
EOF
    
    # Open Firefox with the copied URL using the temporary profile and get its PID
    nohup firefox --no-remote --new-instance --profile "$TEMP_PROFILE" "$url" &
    FIREFOX_PID=$!
    
    # Wait for Firefox to load the page (adjust time if necessary)
    sleep 10

    # Call the Python script to detect and click the download button
    python3 click_download_button.py

    # Wait for 5 seconds to allow the download to start
    sleep 5

    # Close the specific Firefox instance (do not close other instances)
    kill "$FIREFOX_PID"

    # Get the default Downloads directory
    DOWNLOAD_DIR="$HOME/Downloads"

    # Find the most recent downloaded .zip file
    ZIP_FILE=$(ls -t "$DOWNLOAD_DIR"/*.zip | head -n 1)

    # Check if a .zip file was found
    if [ -z "$ZIP_FILE" ]; then
        echo "No .zip file found in the Downloads directory."
        exit 1
    fi

    echo "Downloaded ZIP file: $ZIP_FILE"

    # Create a new directory with the same name as the .zip file (without the .zip extension)
    UNZIPPED_FOLDER="${ZIP_FILE%.zip}"  # Strip .zip extension

    mkdir -p "$UNZIPPED_FOLDER"  # Create the directory

    # Unzip the downloaded .zip file into the newly created directory
    unzip -o "$ZIP_FILE" -d "$UNZIPPED_FOLDER"

    # Check if the unzipping was successful
    if [ $? -ne 0 ]; then
        echo "Failed to unzip the file."
        exit 1
    fi

    echo "Contents of the unzipped directory:"
    ls "$UNZIPPED_FOLDER"

    # Add session suppression preferences to the newly created Firefox profile
    cat <<EOF > "$UNZIPPED_FOLDER/user.js"
user_pref("browser.sessionstore.resume_from_crash", false);
user_pref("browser.startup.page", 0);  # 0 means a blank page at startup
user_pref("browser.startup.homepage_override.mstone", "ignore");  # Prevent first-run tabs
user_pref("browser.tabs.warnOnClose", false);  # Prevent warnings on tab closure
user_pref("browser.warnOnQuit", false);  # Prevent warnings on quitting
user_pref("browser.sessionstore.max_tabs_undo", 0);  # No tab history restore
EOF

    # Remove any session history or restore-related files in the profile directory
    rm -f "$UNZIPPED_FOLDER/sessionstore.js"
    rm -f "$UNZIPPED_FOLDER/sessionCheckpoints.json"
    rm -f "$UNZIPPED_FOLDER/recovery.jsonlz4"
    rm -f "$UNZIPPED_FOLDER/recovery.baklz4"

    # Open Firefox with the new profile (path to the unzipped profile folder) and clear the cache
    nohup firefox --no-remote --new-instance --profile "$UNZIPPED_FOLDER" --purgecaches &

    # Cleanup: remove the temporary profile
    rm -rf "$TEMP_PROFILE"
    echo "Temporary profile deleted."

else
    echo "No valid URL received or URLs are exhausted."
fi
