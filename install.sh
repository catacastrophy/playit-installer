# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or using sudo." >&2
  exit 1
fi

# Define variables
GPG_KEY_URL="https://playit-cloud.github.io/ppa/key.gpg"
GPG_KEY_DEST="/etc/apt/trusted.gpg.d/playit.gpg"
REPO_URL="https://playit-cloud.github.io/ppa/data"
REPO_LIST="/etc/apt/sources.list.d/playit-cloud.list"

# Function to display error and exit
function error_exit {
  echo "Error: $1" >&2
  exit 1
}

# Download GPG key, add to trusted keys, and add PlayIt Cloud repository
curl -SsL "$GPG_KEY_URL" | gpg --dearmor | sudo tee "$GPG_KEY_DEST" >/dev/null || error_exit "Failed to download and add GPG key"
printf "deb [signed-by=%s] %s ./\n" "$GPG_KEY_DEST" "$REPO_URL" | sudo tee "$REPO_LIST" || error_exit "Failed to add PlayIt Cloud repository"

# Update package list
sudo apt update || error_exit "Failed to update package list"

# Install PlayIt.gg client
sudo apt install playit || error_exit "Failed to install playit.gg client"

echo "Playit.gg client installed successfully!"
