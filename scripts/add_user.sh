#!/bin/bash
# Author: Jikai Wang
# Email: jikai.wang@utdallas.edu

# Determine current and project directories
CURR_DIR=$( realpath $(dirname $0) )
PROJ_DIR=$( dirname ${CURR_DIR} )

# Load Configurations from json file
CONFIG_FILE="${PROJ_DIR}/config/config.json"
USER_PASSWORD=$(jq -r '.user_password' "$CONFIG_FILE")

# Check if username is provided
if [ -z "$1" ]; then
  echo "Error: No username provided."
  echo "Usage: $0 <username> <(optional)password>"
  exit 1
fi

USER_NAME=$1
USER_EMAIL="${USER_NAME}@gmail.com"

# Check if password is provided
if [ -z "$2" ]; then
  echo "Warning: No password provided. Using default password."
else
  USER_PASSWORD=$2
fi

# Add user to label-studio
if ! python "${PROJ_DIR}/tools/add_user.py" --email "${USER_EMAIL}" --overwrite; then
  echo "Error: Failed to add user."
  exit 1
fi

# Reset password for the user
if ! docker exec -it label-studio bash -c "label-studio reset_password --username $USER_EMAIL --password $USER_PASSWORD"; then
  echo "Error: Failed to reset password."
  exit 1
fi

echo "User ${USER_EMAIL} added and password reset successfully."
