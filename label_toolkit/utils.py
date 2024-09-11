from pathlib import Path
import json
import logging
import cv2
import numpy as np
from tqdm import tqdm
import shutil
import random

PROJ_ROOT = Path(__file__).resolve().parents[1]


def get_logger(name, level="INFO"):
    logger = logging.getLogger(name)
    logger.setLevel(level.upper())
    formatter = logging.Formatter(
        "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
    )
    console_handler = logging.StreamHandler()
    console_handler.setFormatter(formatter)
    logger.addHandler(console_handler)
    return logger


def generate_random_color(color_type="hex"):
    if color_type == "hex":
        return f"#{random.randint(0, 0xFFFFFF):06x}"
    elif color_type == "rgb":
        return f"rgb({random.randint(0, 255)}, {random.randint(0, 255)}, {random.randint(0, 255)})"
    else:
        raise ValueError(f"Invalid color type: {color_type}")


def make_clean_folder(folder_path):
    folder_path = Path(folder_path)
    if folder_path.exists():
        shutil.rmtree(folder_path)
    folder_path.mkdir(parents=True, exist_ok=True)


def read_data_from_json(file_path):
    with open(file_path, "r") as f:
        data = json.load(f)
    return data


def write_data_to_json(data, file_path):
    with open(file_path, "w") as f:
        json.dump(data, f, indent=4, sort_keys=False, ensure_ascii=True)


def read_rgb_image(image_path):
    return cv2.cvtColor(cv2.imread(str(image_path)), cv2.COLOR_BGR2RGB)


def read_depth_image(image_path):
    return cv2.imread(str(image_path), cv2.IMREAD_ANYDEPTH)


def read_mask_image(image_path):
    return cv2.imread(str(image_path), cv2.IMREAD_GRAYSCALE)


def write_rgb_image(image, image_path):
    cv2.imwrite(str(image_path), cv2.cvtColor(image, cv2.COLOR_RGB2BGR))


def write_depth_image(image, image_path):
    cv2.imwrite(str(image_path), image)


def write_mask_image(image, image_path):
    cv2.imwrite(str(image_path), image)
