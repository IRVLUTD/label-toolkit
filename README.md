# Label Toolkit

## Table of Contents

- [Label Toolkit](#label-toolkit)
  - [Table of Contents](#table-of-contents)
  - [Clone Repository](#clone-repository)
  - [Installation](#installation)
    - [1. Create Conda Environment](#1-create-conda-environment)
    - [2. Install Label Toolkit](#2-install-label-toolkit)
  - [Launch and Stop the Label Toolkit](#launch-and-stop-the-label-toolkit)

## Clone Repository

1. **Clone the repository and navigate to the project directory:**

   ```bash
   git clone git@github.com:gobanana520/label-toolkit.git
   cd label-toolkit
   ```

2. **Initialize and update submodules:**

   Ensure that all submodules are initialized and up to date:

   ```bash
   git submodule update --init --recursive
   ```

3. **Change the permission of the `data/my_data` folder (if needed):**

   Adjust the permissions of the `data/my_data` folder to ensure proper access:

   ```bash
   sudo chown -R 777 data/my_data
   ```

## Installation

### 1. Create Conda Environment

- **Create a Python 3.10 Conda Environment:**

  Set up a new Conda environment with Python 3.10:

  ```bash
  conda create --name label-toolkit python=3.10
  ```

- **Activate the Conda Environment:**

  Activate the newly created environment:

  ```bash
  conda activate label-toolkit
  ```

### 2. Install Label Toolkit

Install the toolkit and its dependencies in editable mode:

```bash
python -m pip install -e .
```

## Launch and Stop the Label Toolkit

1. **Run the Label Toolkit with Docker:**

   Launch the Label Toolkit using Docker Compose:

   ```bash
   docker compose -f docker-compose-sam.yml up -d
   ```

2. **Access the Label Toolkit:**

   Open your browser and navigate to [http://localhost:8080](http://localhost:8080) to access the Label Toolkit.

3. **Stop the Label Toolkit:**

   Stop the running Label Toolkit instance with:

   ```bash
   docker compose -f docker-compose-sam.yml down
   ```