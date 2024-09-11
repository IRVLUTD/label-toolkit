# Label Toolkit

## Table of Contents

1. [Clone Repository](#clone-repository)
2. [Installation](#installation)

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

3. **Change the permission of the `data` folder (if needed):**

   ```bash
   sudo chown -R 777 data
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