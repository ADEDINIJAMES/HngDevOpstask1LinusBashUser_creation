#!/bin/bash

# Constants
LOG_FILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.txt"
GROUP_DELIMITER=","
USER_GROUP_DELIMITER=";"

# Ensure the directories exist and set appropriate permissions
sudo mkdir -p /var/secure
sudo chmod 700 /var/secure

# Function to log messages
log_message() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a "$LOG_FILE"
}

# Function to generate a random password
generate_password() {
  tr -dc A-Za-z0-9 </dev/urandom | head -c 12 ; echo ''
}

# Main script
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <user_list_file>"
  exit 1
fi

USER_LIST_FILE="$1"

if [[ ! -f "$USER_LIST_FILE" ]]; then
  echo "User list file not found!"
  exit 1
fi

# Process each line in the user list file
while IFS="$USER_GROUP_DELIMITER" read -r username groups; do
  username=$(echo "$username" | xargs) # Trim whitespace

  if id -u "$username" >/dev/null 2>&1; then
    log_message "User '$username' already exists. Skipping."
    continue
  fi

  # Create user with home directory
  sudo useradd -m "$username"
  log_message "User '$username' created with home directory."

  # Set user password
  password=$(generate_password)
  echo "$username:$password" | sudo chpasswd
  echo "$username,$password" >> "$PASSWORD_FILE"
  log_message "Password set for user '$username'."

  # Assign user to additional groups if any
  if [[ -n "$groups" ]]; then
    IFS="$GROUP_DELIMITER" read -r -a group_array <<< "$groups"
    for group in "${group_array[@]}"; do
      group=$(echo "$group" | xargs) # Trim whitespace
      if ! getent group "$group" >/dev/null; then
        sudo groupadd "$group"
        log_message "Group '$group' created."
      fi
      sudo usermod -aG "$group" "$username"
      log_message "User '$username' added to group '$group'."
    done
  fi

done < "$USER_LIST_FILE"

# Secure password file
sudo chown root:root "$PASSWORD_FILE"
sudo chmod 600 "$PASSWORD_FILE"
log_message "Password file secured."

log_message "User creation script completed successfully."

exit 0
