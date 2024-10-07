#!/bin/bash
# Author: Jikai Wang
# Email: jikai.wang@utdallas.edu

source "$( realpath $(dirname $0) )/config.sh"

# Load Configurations from json file
USER_PASSWORD=$(jq -r '.user_password' "$CONFIG_FILE")

# Check if username is provided
if [ -z "$1" ]; then
  log_error "No username provided. Usage: $0 <username> <(optional)password>"
fi

USER_NAME=$1
USER_EMAIL="${USER_NAME}@gmail.com"

# Check if password is provided
if [ -z "$2" ]; then
  log_warning "No password provided. Using default password."
else
  USER_PASSWORD=$2
fi

# Add user to label-studio
if ! python "${PROJ_DIR}/tools/add_user.py" --email "${USER_EMAIL}" --overwrite; then
  log_error "Failed to add user: ${USER_EMAIL}"
fi

# Reset password for the user
if ! docker exec -it label-studio bash -c "label-studio reset_password --username $USER_EMAIL --password $USER_PASSWORD"; then
  log_error "Failed to reset password: [${USER_EMAIL}:${USER_PASSWORD}]"
fi

log_message "User ${USER_EMAIL} added and password reset successfully."
