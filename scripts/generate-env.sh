#!/bin/bash
# Author: Jikai Wang
# Email: jikai.wang@utdallas.edu

CURR_DIR=$( realpath $(dirname $0) )
PROJ_DIR=$( dirname ${CURR_DIR} )
DATA_DIR="${PROJ_DIR}/data"

# Fetch the machine's IP address (assuming eth0 is your network interface)
# You might need to adjust 'eth0' depending on your network interface name.
MACHINE_IP=$(hostname -I | awk '{print $1}')

# Set the environment variables for the Label Studio ML backend
LABEL_STUDIO_ML_BACKEND_PATH="${PROJ_DIR}/third-party/label-studio-ml-backend"
LABEL_STUDIO_ACCESS_TOKEN="e6d5a079d1d37809abffa6f00f31b468faac0a23"

# Change this to your model name: MobileSAM or SAM
SAM_CHOICE="SAM"
LOG_LEVEL="INFO"
LABEL_STUDIO_VERSION="20240819.191725-ls-release-1-13-1-d9b816a37"

# Create or overwrite the .env file
cat <<EOF > ${PROJ_DIR}/.env
LABEL_STUDIO_VERSION=${LABEL_STUDIO_VERSION}
LABEL_STUDIO_ML_BACKEND_PATH=${LABEL_STUDIO_ML_BACKEND_PATH}
LABEL_STUDIO_HOST=http://${MACHINE_IP}:8080
LABEL_STUDIO_ACCESS_TOKEN=${LABEL_STUDIO_ACCESS_TOKEN}
DOCKERFILE_PATH=segment_anything_model/Dockerfile
DATA_DIR=${DATA_DIR}
SAM_CHOICE=${SAM_CHOICE}
LOG_LEVEL=${LOG_LEVEL}
EOF

echo ".env file created with the current machine IP: ${MACHINE_IP}"