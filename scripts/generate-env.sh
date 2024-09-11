#!/bin/bash
# Author: Jikai Wang
# Email: jikai.wang@utdallas.edu

# Determine current and project directories
CURR_DIR=$( realpath $(dirname $0) )
PROJ_DIR=$( dirname ${CURR_DIR} )

# Load Configurations from json file
CONFIG_FILE="${PROJ_DIR}/config/config.json"
LABEL_STUDIO_ACCESS_TOKEN=$(jq -r '.label_studio_access_token' "$CONFIG_FILE")
LABEL_STUDIO_IMAGE=$(jq -r '.label_studio_image' "$CONFIG_FILE")
LABEL_STUDIO_ML_BACKEND_MODEL_PATH=$(jq -r '.ml_backend_model_path' "$CONFIG_FILE")
SAM_CHOICE=$(jq -r '.sam_choice' "$CONFIG_FILE")
LOG_LEVEL=$(jq -r '.log_level' "$CONFIG_FILE")


# Create or overwrite the .env file
cat <<EOF > ${PROJ_DIR}/.env
LABEL_STUDIO_IMAGE=${LABEL_STUDIO_IMAGE}
LABEL_STUDIO_HOST=http://label-studio:8080
DATA_DIR=${PROJ_DIR}/data
PROJ_DIR=${PROJ_DIR}
LABEL_STUDIO_ACCESS_TOKEN=${LABEL_STUDIO_ACCESS_TOKEN}
LABEL_STUDIO_ML_BACKEND_MODEL_PATH=${LABEL_STUDIO_ML_BACKEND_MODEL_PATH}
SAM_CHOICE=${SAM_CHOICE}
LOG_LEVEL=${LOG_LEVEL}
EOF

echo ".env file created successfully!"