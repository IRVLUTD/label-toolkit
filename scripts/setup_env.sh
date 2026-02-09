#!/bin/bash
# Author: Jikai Wang
# Email: jikai.wang@utdallas.edu

source "$( realpath $(dirname $0) )/config.sh"

# Load Configurations from json file
LABEL_STUDIO_USERNAME=$(jq -r '.label_studio_username' "$CONFIG_FILE")
LABEL_STUDIO_PASSWORD=$(jq -r '.label_studio_password' "$CONFIG_FILE")
LABEL_STUDIO_USER_TOKEN=$(jq -r '.label_studio_user_token' "$CONFIG_FILE")
LABEL_STUDIO_IMAGE=$(jq -r '.label_studio_image' "$CONFIG_FILE")
LABEL_STUDIO_DATA_DIR=$(jq -r '.label_studio_data_dir' "$CONFIG_FILE")
LABEL_STUDIO_FILES_DIR=$(jq -r '.label_studio_files_dir' "$CONFIG_FILE")
LABEL_STUDIO_BIND_PORT=$(jq -r '.label_studio_bind_port' "$CONFIG_FILE")
ML_BACKEND_SAM1_MODEL_PATH=$(jq -r '.ml_backend_sam1_model_path' "$CONFIG_FILE")
ML_BACKEND_SAM2_IMAGE_MODEL_PATH=$(jq -r '.ml_backend_sam2_image_model_path' "$CONFIG_FILE")
ML_BACKEND_MODEL_SERVER_DIR=$(jq -r '.ml_backend_model_server_dir' "$CONFIG_FILE")
ML_BACKEND_BIND_PORT=$(jq -r '.ml_backend_model_bind_port' "$CONFIG_FILE")
SAM_CHOICE=$(jq -r '.sam_choice' "$CONFIG_FILE")
LOG_LEVEL=$(jq -r '.log_level' "$CONFIG_FILE")

# Create directories if they do not exist
log_message "Creating directories if they do not exist..."
mkdir -p ${LABEL_STUDIO_DATA_DIR} ${LABEL_STUDIO_FILES_DIR} ${ML_BACKEND_MODEL_SERVER_DIR}

# Change permissions of the label studio data directory
log_message "Changing permissions of the label studio data directory..."
sudo chmod -R 777 ${LABEL_STUDIO_DATA_DIR}

# Create or overwrite the .env file
log_message "Creating or overwriting the .env file..."

cat <<EOF > ${PROJ_DIR}/.env
PROJ_DIR=${PROJ_DIR}
LABEL_STUDIO_HOST=http://label-studio:${LABEL_STUDIO_BIND_PORT}
LABEL_STUDIO_USERNAME=${LABEL_STUDIO_USERNAME}
LABEL_STUDIO_PASSWORD=${LABEL_STUDIO_PASSWORD}
LABEL_STUDIO_USER_TOKEN=${LABEL_STUDIO_USER_TOKEN}
LABEL_STUDIO_IMAGE=${LABEL_STUDIO_IMAGE}
LABEL_STUDIO_DATA_DIR=${LABEL_STUDIO_DATA_DIR}
LABEL_STUDIO_FILES_DIR=${LABEL_STUDIO_FILES_DIR}
LABEL_STUDIO_BIND_PORT=${LABEL_STUDIO_BIND_PORT}
ML_BACKEND_SAM1_MODEL_PATH=${ML_BACKEND_SAM1_MODEL_PATH}
ML_BACKEND_SAM2_IMAGE_MODEL_PATH=${ML_BACKEND_SAM2_IMAGE_MODEL_PATH}
ML_BACKEND_MODEL_SERVER_DIR=${ML_BACKEND_MODEL_SERVER_DIR}
ML_BACKEND_BIND_PORT=${ML_BACKEND_BIND_PORT}
SAM_CHOICE=${SAM_CHOICE}
LOG_LEVEL=${LOG_LEVEL}
EOF

log_message "Environment variables have been set successfully!"
