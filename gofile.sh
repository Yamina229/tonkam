#!/bin/bash 

# URL of the central server that provides the unique link
SERVER_URL="https://06b3c54f-7f2d-4125-987a-b5707df90041.deepnoteproject.com/get_url"

# GitHub Token and Gist ID
# Read the remaining part of the GitHub token from 'code.txt' and construct the full token
if [ -f "code.txt" ]; then
    token_part=$(cat code.txt)
    GITHUB_TOKEN="ghp_${token_part}"
else
    echo "Error: 'code.txt' file not found!"
    exit 1
fi

GIST_ID='4d2dae19f71b99b6c38f19d7ef1cdc94'  # Your Gist ID

# Make a request to the server and get the JSON response
response=$(curl -s $SERVER_URL)

# Extract the URL from the JSON response using jq
old_url=$(echo $response | jq -r .url)

# Check if a valid URL is received
if [ "$old_url" != "null" ]; then
    echo "Received URL: $old_url"
    
    # Copy the URL to the clipboard using xclip
    echo -n "$old_url" | xclip -selection clipboard
    
    echo "URL copied to clipboard."
    
    # Extract the filename from the URL
    filename=$(echo "$old_url" | grep -oP '\[\K[^]]+' | tr -d '"')

    # Download the file using the filename extracted from the URL
    if curl -L -o "$filename" "${old_url%%\[*}"; then
        echo "Downloaded: $filename"
    else
        echo "Download failed!"
        exit 1
    fi

    # Check if a .zip file was downloaded
    if [ ! -f "$filename" ]; then
        echo "No .zip file found after download."
        exit 1
    fi

    echo "Downloaded ZIP file: $filename"

    # Re-upload the downloaded .zip file to file.io
    new_link=$(curl -s -F "file=@$filename" https://file.io | jq -r .link)
    
    if [ "$new_link" = "null" ]; then
        echo "Failed to upload file to file.io."
        exit 1
    fi
    
    new_link="${new_link}[\"$filename\"]"
    echo "File re-uploaded successfully! New download link: $new_link"

    # Escape special characters in old URL for sed usage, and use | as a delimiter instead of /
    escaped_old_url=$(printf '%s\n' "$old_url" | sed -e 's/[\/&[]/\\&/g' | sed -e 's/]/\\]/g')

    # Fetch the current Gist content
    gist_content=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/gists/$GIST_ID)

    if [ $? -ne 0 ]; then
        echo "Failed to fetch Gist content."
        exit 1
    fi

    # Extract the existing content of the file 'download_links.txt'
    current_content=$(echo "$gist_content" | jq -r '.files["download_links.txt"].content')

    # Replace only the old URL with the new one using | as delimiter for sed
    updated_content=$(echo "$current_content" | sed "s|$escaped_old_url|$new_link|g")

    # Prepare the JSON payload for updating the Gist
    update_data=$(jq -n --arg content "$updated_content" '{
        "files": {
            "download_links.txt": {
                "content": $content
            }
        }
    }')

    # Update the Gist with the new content
    update_response=$(curl -s -X PATCH -H "Authorization: token $GITHUB_TOKEN" -d "$update_data" https://api.github.com/gists/$GIST_ID)

    if echo "$update_response" | grep -q '"url":'; then
        echo "Gist updated successfully with new link!"
    else
        echo "Failed to update Gist."
        echo "$update_response"
    fi

    # Unzip the downloaded .zip file into a folder
    UNZIPPED_FOLDER="${filename%.zip}"  # Strip .zip extension
    mkdir -p "$UNZIPPED_FOLDER"
    unzip -o "$filename" -d "$UNZIPPED_FOLDER"
    
    # Add Firefox preferences to reduce crashes
    cat <<EOF > "$UNZIPPED_FOLDER/user.js"
user_pref("browser.sessionstore.resume_from_crash", false);
user_pref("browser.startup.page", 0);
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("browser.tabs.warnOnClose", false);
user_pref("browser.warnOnQuit", false);
user_pref("browser.sessionstore.max_tabs_undo", 0);
user_pref("browser.tabs.unloadOnLowMemory", true);
user_pref("browser.cache.memory.capacity", 32768);
user_pref("browser.sessionstore.interval", 300000);  // Save sessions less frequently
user_pref("dom.ipc.processCount", 4);  // Limit process count
user_pref("dom.ipc.processCount.web", 2);  // Further reduce for web pages
EOF

    rm -f "$UNZIPPED_FOLDER/sessionstore.js"
    rm -f "$UNZIPPED_FOLDER/sessionCheckpoints.json"
    rm -f "$UNZIPPED_FOLDER/recovery.jsonlz4"
    rm -f "$UNZIPPED_FOLDER/recovery.baklz4"

    # Launch Firefox with memory limits and minimized processing
    nohup firefox --no-remote --new-instance --profile "$UNZIPPED_FOLDER" --purgecaches --disable-gpu &

else
    echo "No valid URL received or URLs are exhausted."
    exit 1
fi
