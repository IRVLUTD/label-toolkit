#!/bin/bash
# Author: Jikai Wang
# Email: jikai.wang@utdallas.edu

source "$( realpath $(dirname $0) )/config.sh"

# Check if scene folder is provided
if [ -z "$1" ]; then
    log_error "No scene folder provided."
    log_message "Usage: $0 <scene_folder_path>"
    exit 1
fi

SCENE_DIR=$1

# Check if the scene folder exists
if [ ! -d "${SCENE_DIR}" ]; then
    log_error "Scene folder does not exist: ${SCENE_DIR}"
fi

# Change the permissions of the scene folder
log_message "Changing permissions of the scene folder..."
sudo chmod -R 777 ${SCENE_DIR}

# Add project to label-studio
if ! python "${PROJ_DIR}/tools/add_project.py" --scene_folder "${SCENE_DIR}"; then
    log_error "Failed to add project for ${SCENE_DIR}"
fi

log_message "Project created successfully."
