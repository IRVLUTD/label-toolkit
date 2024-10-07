#!/bin/bash
# Author: Jikai Wang
# Email: jikai.wang@utdallas.edu

# Define functions
log_message() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_warning() {
    echo "[WARNING] $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $1"
    exit 1
}

# Get the current directory and project root
CURR_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
PROJ_DIR=$(realpath "${CURR_DIR}/..")

# Configuration file path
CONFIG_FILE="${PROJ_DIR}/config/config.json"
