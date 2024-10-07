# Label Toolkit

---

## Introduction

The Label Toolkit is built on top of [Label Studio](https://github.com/HumanSignal/label-studio) and the [Label Studio ML Backend](https://github.com/HumanSignal/label-studio-ml-backend), providing a web-based tool for efficient data labeling and annotation. Designed specifically to support SAM backend for annotating 2D image data, Label Toolkit offers a user-friendly interface for creating segmentation masks by prompting keypoints or bounding boxes, and assigning text labels to those masks.

---

## Table of Contents

- [Label Toolkit](#label-toolkit)
  - [Introduction](#introduction)
  - [Table of Contents](#table-of-contents)
  - [Environment Setup](#environment-setup)
  - [Launch and Stop the Label Toolkit](#launch-and-stop-the-label-toolkit)
  - [Example Usage](#example-usage)

---

## Environment Setup

1. **Create Conda Environment**

   Set up a Python environment for Label Toolkit using Conda:

   ```bash
   conda create --name label-toolkit python=3.10
   conda activate label-toolkit
   ```

2. **Clone the Repository**

   Clone the Label Toolkit repository and initialize submodules:

   ```bash
   git clone https://github.com/gobanana520/label-toolkit.git
   cd label-toolkit
   git submodule update --init --recursive
   ```

3. **Install Dependencies**

   Install required dependencies from requirements.txt:

   ```bash
   python -m pip install --no-cache-dir -r requirements.txt
   ```

4. **Install label-toolkit**

   Install Label Toolkit in editable mode:

   ```bash
   python -m pip install -e . --no-cache-dir
   ```

5. **Generate Environment Variables for Docker**

   Run the script to create a `.env` file:

   ```bash
   bash scripts/create_env.sh
   ```

---

## Launch and Stop the Label Toolkit

1. **Run the Label Toolkit with Docker**

   Use Docker Compose to start Label Toolkit:

   ```bash
   docker compose up -d
   ```

1. **Access the Label Toolkit**

   Open a browser and go to http://localhost:8080/user/login/ to access Label Toolkit.

1. **Stop the Label Toolkit**

   To stop the service, run:

   ```bash
   docker compose down
   ```

---

## Example Usage

1. **Add users to the Label Toolkit**

   By default, an admin user (admin@gmail.com) is available. To add more users, use the following script:

   ```bash
   bash scripts/add_user.sh <username> <(optional)password>
   ```

   This script will create a new user with the specified email format `<username>@gmail.com`. If a password is not provided, the default password will be set to `label-studio`.

2. **Add a New Project from Scene Folder**

   Add a project by specifying a folder containing scene images:

   ```bash
   bash scripts/add_project.sh <path/to/scene/folder>
   ```

   This script adjusts folder permissions, creates a project named after the scene folder, adds all `*.jpg` images to the project, and configures SAM backend integration.

3. **Demo to Create Annotation**

   Below is a demonstration of creating annotations using SAM backend integration:

   ![Annotation Demo](./docs/assets/ml-backend-sam-demo_1080p.gif)
